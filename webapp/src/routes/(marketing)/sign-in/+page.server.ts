import { fail, redirect } from "@sveltejs/kit";
import { PUBLIC_API_BASE_URL, PUBLIC_APP_BASE_URL } from "$env/static/public";
import type { Actions, PageServerLoadEvent } from "./$types";

export async function load({ cookies }: PageServerLoadEvent) {
  const identity = cookies.get("identity");
  if (identity) {
    throw redirect(303, PUBLIC_APP_BASE_URL);
  }
  return {};
}

export const actions: Actions = {
  default: async ({ cookies, request, fetch }) => {
    const data = await request.formData();
    const username = data.get("username");
    const password = data.get("password");

    const response = await fetch(`${PUBLIC_API_BASE_URL}/api/auth`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, password }),
    });
    if (!response.ok) {
      return fail(response.status, await response.json());
    }
    const { identity_token } = await response.json();
    cookies.set("identity", identity_token);
    throw redirect(303, PUBLIC_APP_BASE_URL);
  },
};
