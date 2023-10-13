import { randomUUID } from "node:crypto";
import pino from "pino";
import { ValidationError } from "runtypes";
import { Prisma, PrismaClient, type Session } from "@prisma/client";
import { DATABASE_URL, LOG_LEVEL } from "$env/static/private";
import type { Handle, HandleServerError } from "@sveltejs/kit";
import { error } from "$lib/server/response";

const logger = pino({ level: LOG_LEVEL });
const client = new PrismaClient({
  datasourceUrl: DATABASE_URL,
  log: [
    { emit: "event", level: "query" },
    { emit: "event", level: "error" },
    { emit: "event", level: "info" },
    { emit: "event", level: "warn" },
  ],
});
client.$on("query", (event: Prisma.QueryEvent) => logger.trace(event, "%s", event.query));
client.$on("error", (event: Prisma.LogEvent) => logger.error(event, "%s", event.message));
client.$on("info", (event: Prisma.LogEvent) => logger.info(event, "%s", event.message));
client.$on("warn", (event: Prisma.LogEvent) => logger.warn(event, "%s", event.message));

export async function handle({ event, resolve }: Parameters<Handle>[0]): Promise<Response> {
  event.locals.requestId = randomUUID();

  // `event.locals.sessionId` is the current session ID. If undefined, then there is
  // no active session.
  event.locals.sessionId = event.cookies.get("bale-session");

  // We're not allowed to touch the cookies after the request function generates the response,
  // so instead the getter/setter makes sure cookie adjustments are done up front. Meanwhile we
  // want the setting of the session data to be synchronous, so we store discarded sessions to
  // delete for later.
  const sessionsDiscarded: string[] = [];
  let session: (Partial<Session> & { accountId: string }) | undefined | null; // A cache, to only load from DB if needed
  event.locals.session = async () => {
    if (session) return session;
    const id = event.locals.sessionId;
    if (!id) return undefined;
    session = await client.session.findUnique({ where: { id } });
    return session ?? undefined;
  };

  event.locals.setSession = (
    newSession: (Partial<Session> & { accountId: string }) | undefined | null,
  ) => {
    if (event.locals.sessionId && newSession?.id !== event.locals.sessionId) {
      sessionsDiscarded.push(event.locals.sessionId);
    }
    session = newSession;
    if (!session) {
      event.locals.sessionId = undefined;
      event.cookies.delete("bale-session", {
        path: "/",
        httpOnly: true,
        secure: true,
        sameSite: true,
      });
    } else {
      session.id ??= randomUUID();
      event.locals.sessionId = session.id;
      event.cookies.set("bale-session", session.id, {
        path: "/",
        httpOnly: true,
        secure: true,
        sameSite: true,
      });
    }
  };

  event.locals.logger = logger.child({ request: event.locals.requestId });
  event.locals.database = client;

  event.locals.formData = async (schema) => {
    try {
      const data = await event.request.formData();
      const body = Object.fromEntries(data);
      return schema.check(body);
    } catch (err) {
      if (err instanceof ValidationError) {
        throw error(400, {
          code: "ValidationError",
          message: err.message,
          context: { code: err.code, details: err.details },
        });
      }
      throw err;
    }
  };

  try {
    return await resolve(event);
  } finally {
    try {
      await client.session.deleteMany({ where: { id: { in: sessionsDiscarded } } });
      if (session?.id) {
        await client.session.upsert({
          where: { id: session?.id },
          update: session,
          create: session,
        });
      }
    } catch (error) {
      event.locals.logger.error(error, "Persisting session changes failed");
    }
  }
}

export async function handleError({
  error,
  event,
}: Parameters<HandleServerError>[0]): Promise<App.Error> {
  event.locals.logger.error({ err: error }, "Unhandled server error");
  return {
    code: "InternalServerError",
    message:
      error && typeof error === "object" && "message" in error && typeof error.message === "string"
        ? error.message
        : "An unexpected error has occurred",
    context: error,
  };
}
