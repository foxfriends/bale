<script lang="ts">
  import { browser } from "$app/environment";
  import { getPortal } from "$lib/actions/portal";
  import { writable } from "svelte/store";
  import { fly, scale } from "svelte/transition";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import { scrollOffset } from "$lib/util/scrollOffset";

  const label = browser ? window.crypto.randomUUID() : undefined;
  const portal = getPortal();

  export let open = false;
  export let style: "error" = "error";

  let anchor: HTMLDivElement;
  let target: { x: number; y: number } | undefined;
  $: if (open && anchor) {
    const { x, width, y } = anchor.getBoundingClientRect();
    const { x: scrollX, y: scrollY } = scrollOffset(anchor);
    target = { x: x + scrollX + width / 2, y: y + scrollY - 4 };
  }
</script>

<div
  on:mouseenter={() => (open = true)}
  on:mouseleave={() => (open = false)}
  role="status"
  aria-describedby={label}
  bind:this={anchor}
>
  <slot />
</div>

{#if open && target}
  <div
    use:portal
    transition:scale={{ start: $prefersReducedMotion ? 1 : 0.95, opacity: 0, duration: 100 }}
    class="tooltip {style}"
    role="tooltip"
    id={label}
    style="left: {target.x}px; top: {target.y}px;"
  >
    <div class="tip-arrow" />
    <div class="tip-content">
      <slot name="tip" />
    </div>
  </div>
{/if}

<svelte:window on:keydown={(event) => event.key === "Escape" && (open = false)} />

<style>
  .tooltip {
    position: absolute;
    top: 0;
    left: 0;
    transform-origin: bottom center;
    pointer-events: none;
  }

  .tip-content {
    background-color: rgb(var(--tip-color));
    border-radius: var(--radius-sm);
    position: absolute;
    left: 50%;
    bottom: 0;
    transform: translate(-50%, 0);
    width: max-content;
  }

  .tip-arrow {
    position: absolute;
    left: 50%;
    top: 100%;
    width: var(--12);
    height: var(--12);
    transform: translate(-50%, -75%) rotate(45deg);
    background-color: rgb(var(--tip-color));
    border-bottom-right-radius: var(--radius-xs);
  }

  .error {
    --tip-color: var(--rgb-danger);
  }
</style>
