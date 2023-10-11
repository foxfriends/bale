import { randomUUID } from "node:crypto";
import { Prisma, PrismaClient } from "@prisma/client";
import { DATABASE_URL, LOG_LEVEL } from "$env/static/private";
import pino from "pino";
import type { Handle, HandleServerError } from "@sveltejs/kit";
import { error } from "$lib/server/response";
import { ValidationError } from "runtypes";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";

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
  event.locals.id = randomUUID();

  const sessionid = event.cookies.get("bale-session");
  const session = sessionid
    ? await client.session.findUnique({ where: { id: sessionid } })
    : undefined;
  event.locals.session = session ?? undefined;

  event.locals.logger = logger.child({ request: event.locals.id });
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
      if (event.locals.session) {
        const { id } = await client.session.upsert({
          where: { id: event.locals.session.id },
          update: event.locals.session,
          create: event.locals.session,
          select: { id: true },
        });
        event.cookies.set("bale-session", id);
      } else if (sessionid) {
        await client.session.delete({ where: { id: sessionid } });
        event.cookies.delete("bale-session");
      }
    } catch (error) {
      event.locals.logger.error(error, "Updating session failed");
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
