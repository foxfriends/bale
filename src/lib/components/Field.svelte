<script lang="ts">
  import Blinker from "./Blinker.svelte";

  export let error: string | undefined = undefined;
</script>

<label>
  <slot name="label" />
  <slot />
  {#if error !== undefined}
    <div class="indicator">
      <Blinker style="error" />
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
