<script lang="ts">
  import Blinker from "./Blinker.svelte";
  import Tooltip from "./Tooltip.svelte";

  export let error: string | undefined = undefined;
</script>

<label>
  <slot />

  {#if error !== undefined}
    <div class="indicator">
      <Tooltip>
        <div slot="tip">
          {error}
        </div>
        <Blinker style="error" />
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
