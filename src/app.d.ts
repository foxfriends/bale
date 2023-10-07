// See https://kit.svelte.dev/docs/types#app

import type { PrismaClient } from "@prisma/client";
import type { Logger } from "pino";

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
    }

    // interface PageData {}

    // interface Platform {}
  }
}

export {};
