import { randomUUID } from "node:crypto";
import { PrismaClient } from "@prisma/client";
import { LOG_LEVEL } from "$env/static/private";
import type { Handle, HandleServerError } from "@sveltejs/kit";
import pino from "pino";

const client = new PrismaClient();
const logger = pino({ level: LOG_LEVEL });

export async function handle({ event, resolve }: Parameters<Handle>[0]): Promise<Response> {
  event.locals.id = randomUUID();
  event.locals.logger = logger.child({ request: event.locals.id });
  event.locals.database = client;
  return resolve(event);
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
