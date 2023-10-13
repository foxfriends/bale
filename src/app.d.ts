// See https://kit.svelte.dev/docs/types#app

import type { PrismaClient, Session } from "@prisma/client";
import type { Logger } from "pino";
import type { RuntypeBase, Static } from "runtypes";

// for information about these interfaces
declare global {
  namespace App {
    interface Error {
      code: string;
      message: string;
      context: unknown;
    }

    interface Locals {
      requestId: string;
      logger: Logger;
      database: PrismaClient;
      /** The current session ID. If undefined, there is no session */
      sessionId?: string;
      /** Retrieves the current session. The current session will be pulled from database at most once */
      session(): Promise<Partial<Session> | undefined>;
      /** Sets the current session, updating `sessionId` and the return value of `session()` accordingly */
      setSession(session: (Partial<Session> & { accountId: string }) | null);
      formData<T extends RuntypeBase>(this: void, runtype: T): Promise<Static<T>>;
    }

    // interface PageData {}

    // interface Platform {}
  }
}

export {};
