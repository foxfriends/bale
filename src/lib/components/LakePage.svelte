<script lang="ts">
  import Waterline from "./Waterline.svelte";
  import PageFooter from "./PageFooter.svelte";
  import PageNav from "./PageNav.svelte";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import { page } from "$app/stores";
</script>

<div class="page">
  <div class="nav">
    <PageNav account={$page.data.session?.account}>
      <slot name="title" />
    </PageNav>
  </div>
  <div class="backing">
    <Waterline above shape={[3, 2, 3, 3, 2, 3]} height={4} flow={$prefersReducedMotion ? 0 : 0.1} />
  </div>
  <main>
    <slot />
  </main>
  <div class="foot">
    <PageFooter />
  </div>
</div>

<style>
  .page {
    container-type: normal;
    min-height: 100vh;
    display: grid;
    grid-template-rows:
      [nav-start]
      auto
      [nav-end safe-start]
      1fr
      [safe-end foot-start]
      auto
      [foot-end];
    grid-template-columns:
      [left-start]
      1fr
      [left-end main-start]
      minmax(auto, var(--width-page))
      [main-end right-start]
      1fr
      [right-end];
  }

  .foot {
    grid-row: foot-start / foot-end;
    grid-column: 1 / -1;
  }

  .nav {
    grid-row: nav-start / nav-end;
    grid-column: 1 / -1;
  }

  .backing {
    grid-row: 1 / -1;
    grid-column: 1 / -1;
    align-self: start;
    height: var(--440);
  }

  main {
    container-type: inline-size;
    width: calc(100vw - var(--32));
    margin: 0 auto;
    max-width: var(--width-page);
    grid-row: safe-start / safe-end;
    grid-column: main-start / main-end;
  }
</style>
