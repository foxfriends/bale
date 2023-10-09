<script lang="ts">
  import { writable } from "svelte/store";
  import { createPortal, setPortal } from "$lib/actions/portal";

  const portal = writable<HTMLElement | undefined>();
  setPortal(createPortal(portal));
</script>

<div class="layer"><slot /></div>
<div class="layer" bind:this={$portal} />

<style>
  .layer {
    isolation: isolate;
  }
</style>
