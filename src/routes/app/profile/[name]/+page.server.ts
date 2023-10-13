import { notFound } from "$lib/server/response";
import type { RequestEvent } from "./$types";

export async function load({ params, locals }: RequestEvent) {
  const account = await locals.database.account.findUnique({
    where: { name: params.name },
    include: { profile: true },
  });
  if (!account) {
    throw notFound("Account could not be found", "Account");
  }
  return { account };
}
