<script lang="ts">
  import type { ComponentType } from "svelte";
  import Blinker from "./Blinker.svelte";
  import Tooltip from "./Tooltip.svelte";

  export let error: string | undefined | null = undefined;
  export let icon: ComponentType | undefined = undefined;

  let tooltipOpen = true;
  $: tooltipOpen = !!error;
</script>

<label on:focusin={() => (tooltipOpen = true)} on:focusout={() => (tooltipOpen = false)} data-field>
  <slot />

  {#if error}
    <div class="indicator">
      <Tooltip bind:open={tooltipOpen}>
        <Blinker style="error" seen />

        <div slot="tip" class="tip">
          {error}
        </div>
      </Tooltip>
    </div>
  {/if}

  {#if icon}
    <div class="icon">
      <svelte:component this={icon} />
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

  .tip {
    color: rgb(var(--rgb-cloud));
    padding: var(--8);
    font-weight: 500;
  }

  .icon {
    display: flex;
    align-self: center;
    margin-right: var(--4);
    color: rgb(var(--rgb-black) / 0.6);
  }

  label:focus-within {
    outline: 2px solid rgb(var(--rgb-turtle));
  }

  label:focus-within .icon {
    color: color-mix(in srgb, rgb(var(--rgb-black)) 20%, rgb(var(--rgb-turtle) / 0.6));
  }

  label :global(input) {
    outline: none;
  }
</style>
