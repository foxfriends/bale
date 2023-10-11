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
      id: string;
      logger: Logger;
      database: PrismaClient;
      session?: Partial<Session> & {
        accountId: string;
      };
      formData<T extends RuntypeBase>(this: void, runtype: T): Promise<Static<T>>;
    }

    // interface PageData {}

    // interface Platform {}
  }
}

export {};
