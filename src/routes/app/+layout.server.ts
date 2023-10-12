import type { RequestEvent } from "./$types";
import { error } from "$lib/server/response";

export async function load({ locals }: RequestEvent) {
  if (!locals.session?.accountId) {
    throw error(401, { code: "NotLoggedIn", message: "You are not logged in" });
  }
  const account = await locals.database.account.findUniqueOrThrow({
    where: { id: locals.session.accountId },
  });
  return { session: locals.session, account };
}
