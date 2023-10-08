import { browser } from "$app/environment";
import { readable } from "svelte/store";

export const prefersReducedMotion = readable(false, (set) => {
  function update({ matches }: MediaQueryListEvent) {
    set(matches);
  }

  if (browser) {
    const query = window.matchMedia("(prefers-reduced-motion: reduce)");
    set(query.matches);
    query.addEventListener("change", update);
    return () => query.removeEventListener("change", update);
  }
});
