import { redirect } from "@sveltejs/kit";
import type { LayoutServerLoadEvent } from "./$types";

export async function load({ cookies }: LayoutServerLoadEvent) {
  const identity = cookies.get("identity");
  if (!identity) {
    throw redirect(303, "/sign-in/");
  }
  return {
    identity,
  };
}
