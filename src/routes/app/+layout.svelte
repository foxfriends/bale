<script lang="ts">
  import PageFooter from "$lib/components/PageFooter.svelte";
  import PageNav from "$lib/components/PageNav.svelte";
</script>

<div class="page">
  <PageNav />
  <main>
    <slot />
  </main>
  <PageFooter />
</div>

<style>
  .page {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  main {
    flex-grow: 1;
  }
</style>
