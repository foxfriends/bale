import { browser } from "$app/environment";
import { readable, type Readable } from "svelte/store";

export function intersectionObserver(
  element: Readable<HTMLElement | null>,
  init?: IntersectionObserverInit,
): Readable<IntersectionObserverEntry[]> {
  if (!browser) return readable();
  return readable<IntersectionObserverEntry[]>([], (set) => {
    const observer = new IntersectionObserver(set, init);
    return element.subscribe((element) => {
      if (element) {
        observer.observe(element);
        return () => observer.unobserve(element);
      }
    });
  });
}
