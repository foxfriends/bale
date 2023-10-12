import { notFound } from "$lib/server/response";
import type { RequestEvent } from "./$types";

export function load({ params, locals }: RequestEvent) {
  const account = locals.database.account.findUnique({ where: { name: params.name } });

  if (!account) {
    throw notFound("Profile could not be found", "Account");
  }

  return { profile: account };
}
