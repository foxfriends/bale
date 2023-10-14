<script lang="ts">
  import Waterline from "./Waterline.svelte";
  import PageFooter from "./PageFooter.svelte";
  import PageNav from "./PageNav.svelte";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import { page } from "$app/stores";
</script>

<div class="page">
  <PageNav account={$page.data.session?.account}>
    <slot name="title" />
  </PageNav>
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
      minmax(auto, var(--128))
      [left-end main-start]
      1fr
      [main-end right-start]
      minmax(auto, var(--360))
      [right-end];
    flex-direction: column;
  }

  .foot {
    grid-row: foot-start / foot-end;
    grid-column: 1 / -1;
  }

  .backing {
    grid-row: 1 / -1;
    grid-column: 1 / -1;
    align-self: start;
    height: var(--440);
  }

  main {
    width: 100vw;
    max-width: var(--width-page);
    grid-row: safe-start / safe-end;
    grid-column: 1 / -1;
  }

  @media (min-width: 100rem) {
    .page {
      grid-template-columns:
        [left-start]
        1fr
        [left-end main-start]
        auto
        [main-end right-start]
        minmax(auto, 1fr)
        [right-end];
    }

    main {
      grid-column: main-start / main-end;
    }
  }
</style>
