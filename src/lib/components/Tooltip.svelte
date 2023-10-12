<script lang="ts">
  import { browser } from "$app/environment";
  import { getPortal } from "$lib/actions/portal";
  import { writable } from "svelte/store";
  import { scale } from "svelte/transition";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import { intersectionObserver } from "$lib/stores/intersectionObserver";
  import { scrollOffset } from "$lib/util/scrollOffset";

  const label = browser ? window.crypto.randomUUID() : undefined;
  const portal = getPortal();

  export let open = false;
  export let style: "error" = "error" as const;

  let anchor: HTMLDivElement;
  let target: { x: number; y: number } | undefined;

  function reposition() {
    const { x, width, y } = anchor.getBoundingClientRect();
    const { x: scrollX, y: scrollY } = scrollOffset(anchor);
    target = { x: x + scrollX + width / 2, y: y + scrollY - 4 };
  }

  $: if (open && anchor) reposition();

  function dismiss() {
    open = false;
  }

  const tooltip = writable<HTMLDivElement | null>(null);
  const intersection = intersectionObserver(tooltip);

  $: overlap = 100 * (1 - ($intersection?.[0]?.intersectionRatio || 1));
  $: shift = overlap
    ? `transform: translateX(calc(0px - ${overlap}% - 1rem))`
    : "transform: translateX(0)";
</script>

<div
  on:mouseenter={() => (open = true)}
  on:mouseleave={dismiss}
  role="status"
  aria-describedby={label}
  bind:this={anchor}
>
  <slot />
</div>

{#if open && target}
  <!-- svelte-ignore a11y-click-events-have-key-events -->
  <!-- svelte-ignore a11y-no-noninteractive-element-interactions -->
  <div
    use:portal
    transition:scale={{ start: $prefersReducedMotion ? 1 : 0.95, opacity: 0, duration: 100 }}
    on:mouseleave={dismiss}
    on:click={dismiss}
    class="tooltip {style}"
    role="tooltip"
    id={label}
    style="left: {target.x}px; top: {target.y}px;"
  >
    <div class="tip-arrow" />
    <div class="tip-content-wrapper" bind:this={$tooltip}>
      <div class="tip-content" style={shift}>
        <slot name="tip" />
      </div>
    </div>
  </div>
{/if}

<svelte:window
  on:keydown={(event) => event.key === "Escape" && dismiss()}
  on:resize={() => open && reposition()}
/>

<style>
  .tooltip {
    position: absolute;
    top: 0;
    left: 0;
    transform-origin: bottom center;
  }

  .tip-content-wrapper {
    position: absolute;
    left: 50%;
    bottom: 0;
    transform: translate(-50%, 0);
  }

  .tip-content {
    background-color: rgb(var(--tip-color));
    border-radius: var(--radius-sm);
    width: max-content;
    transition: 0.2s transform 50ms;
    cursor: pointer;
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
    pointer-events: none;
  }

  .error {
    --tip-color: var(--rgb-danger);
  }
</style>
