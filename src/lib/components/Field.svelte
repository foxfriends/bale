<script lang="ts">
  import type { ComponentType } from "svelte";
  import Blinker from "./Blinker.svelte";
  import Tooltip from "./Tooltip.svelte";
  import Tip from "./Tip.svelte";

  export let error: string | undefined | null = undefined;

  let tooltipOpen = true;
  $: tooltipOpen = !!error;
</script>

<label on:focusin={() => (tooltipOpen = true)} on:focusout={() => (tooltipOpen = false)} data-field>
  <slot />

  {#if error}
    <div class="indicator">
      <Tooltip bind:open={tooltipOpen} style="error">
        <Blinker style="error" seen />

        <Tip slot="tip">
          {error}
        </Tip>
      </Tooltip>
    </div>
  {/if}

  {#if $$slots.icon}
    <div class="icon">
      <slot name="icon" />
    </div>
  {/if}
</label>

<style>
  label {
    position: relative;
    display: flex;
    flex-direction: row;
    gap: var(--4);
    background-color: rgb(var(--rgb-cloud));
    border-radius: var(--radius-sm);
  }

  .indicator {
    position: absolute;
    top: var(--4);
    right: var(--4);
  }

  .icon {
    display: flex;
    align-self: center;
    margin-right: var(--4);
    color: rgb(var(--rgb-black) / 0.6);
    font-size: var(--24);
  }

  label:focus-within {
    outline: 2px solid rgb(var(--rgb-turtle));
  }

  label:focus-within .icon {
    color: color-mix(in srgb, rgb(var(--rgb-black)) 25%, rgb(var(--rgb-turtle)));
  }

  label :global(input) {
    outline: none;
  }
</style>
