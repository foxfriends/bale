import { json } from "@sveltejs/kit";
import { error } from "$lib/server/response";
import type { RequestEvent } from "./$types";

export async function GET({ cookies, locals }: RequestEvent): Promise<Response> {
  const id = cookies.get("bale-session");
  if (!id) {
    throw error(401, {
      code: "NoSession",
      message: "Not logged in",
    });
  }
  const session = await locals.database.session.findUnique({ where: { id } });
  if (session === null) {
    throw error(401, {
      code: "NoSession",
      message: "Not logged in",
    });
  }
  return json({ session });
}

export async function DELETE({ cookies }: RequestEvent): Promise<Response> {
  cookies.delete("bale-session");
  return new Response(null, { status: 204 });
}
