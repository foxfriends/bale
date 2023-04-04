import { redirect } from "@sveltejs/kit";
import type { PageServerLoadEvent } from "./$types";
import { PUBLIC_APP_BASE_URL } from "$env/static/public";

export async function load({ cookies }: PageServerLoadEvent) {
  const identity = cookies.get("identity");
  if (!identity) {
    throw redirect(303, PUBLIC_APP_BASE_URL);
  }
  return {};
}
