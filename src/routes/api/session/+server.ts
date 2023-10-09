import { json } from "@sveltejs/kit";
import { error } from "$lib/server/response";
import type { RequestEvent } from "./$types";

export async function GET({ locals }: RequestEvent): Promise<Response> {
  if (!locals.session) {
    throw error(401, {
      code: "NoSession",
      message: "Not logged in",
    });
  }
  return json({ session: locals.session });
}

export async function DELETE({ locals }: RequestEvent): Promise<Response> {
  delete locals.session;
  return new Response(null, { status: 204 });
}
