import { error } from "$lib/server/response";
import type { RequestEvent } from "./$types";

export async function load({ locals }: RequestEvent) {
  if (!locals.sessionId) {
    throw error(401, { code: "NotSignedIn", message: "You must be signed in to view this page" });
  }
  const session = await locals.database.session.findUnique({
    where: { id: locals.sessionId },
    include: { account: true },
  });
  if (session === null) {
    throw error(401, { code: "SessionExpired", message: "Your session has expired" });
  }
  return { session };
}
