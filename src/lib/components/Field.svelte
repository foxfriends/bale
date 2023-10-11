<script lang="ts">
  import Blinker from "./Blinker.svelte";
  import Tooltip from "./Tooltip.svelte";

  export let error: string | undefined | null = undefined;

  let tooltipOpen = true;
  $: tooltipOpen = !!error;
</script>

<label on:focusin={() => (tooltipOpen = true)} on:focusout={() => (tooltipOpen = false)}>
  <slot />

  {#if error}
    <div class="indicator">
      <Tooltip bind:open={tooltipOpen}>
        <Blinker style="error" seen />

        <div slot="tip">
          {error}
        </div>
      </Tooltip>
    </div>
  {/if}
</label>

<style>
  label {
    position: relative;
  }

  .indicator {
    position: absolute;
    top: var(--4);
    right: var(--4);
  }
</style>
