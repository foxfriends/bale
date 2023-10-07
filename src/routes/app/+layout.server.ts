import type { RequestEvent } from "./$types";

export async function load({ fetch }: RequestEvent) {
  const response = await fetch("/api/session");
  if (response.status === 401) {
    return { session: null };
  }
  const { session } = await response.json();
  return { session };
}
