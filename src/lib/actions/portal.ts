import { getContext, setContext } from "svelte";
import type { Action } from "svelte/action";
import type { Readable } from "svelte/store";

export function createPortal(target: Readable<HTMLElement | undefined>): Action {
  return (element: HTMLElement) => {
    element.remove();

    const unsubscribe = target.subscribe((target) =>
      target ? target.appendChild(element) : element.remove(),
    );

    function destroy() {
      element.remove();
      unsubscribe();
    }

    return { destroy };
  };
}

type Portal = ReturnType<typeof createPortal>;

const PORTAL = Symbol("portal");

export function setPortal(portal: Portal) {
  setContext(PORTAL, portal);
}

export function getPortal(): Portal {
  return getContext(PORTAL);
}
