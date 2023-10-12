<script lang="ts">
  import Page from "./+page.svelte";
  import { page } from "$app/stores";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import Waterline from "$lib/components/Waterline.svelte";
  import PageFooter from "$lib/components/PageFooter.svelte";
  import TextLink from "$lib/components/TextLink.svelte";
</script>

{#if $page.route.id === "/"}
  <Page />
{:else}
  <main>
    <article>
      <header>
        <h1>Uh oh</h1>
        <h2>We've run into a little trouble.</h2>
      </header>

      <section>
        {#if $page.error}
          {#if $page.error.code === "NotLoggedIn"}
            <p>You need to be logged in to view this page.</p>
            <p class="cta"><TextLink href="/">Go to login &rarr;</TextLink></p>
          {:else}
            <p>Something unexpected has happened.</p>
            <p>{$page.error.message}</p>
            <p class="cta"><TextLink href="/">Go to home page &rarr;</TextLink></p>
          {/if}
        {:else}
          <p>Something unexpected has happened.</p>
          <p class="cta"><TextLink href="/">Go to home page &rarr;</TextLink></p>
        {/if}
      </section>
    </article>
    <Waterline
      shape={[2, 3, 2, 1, 2, 3]}
      height={4}
      width={32}
      flow={$prefersReducedMotion ? 0 : 0.3}
    />
    <div class="water">
      <PageFooter />
    </div>
  </main>
{/if}

<style>
  main {
    min-height: 100vh;
    display: flex;
    flex-direction: column;
  }

  article {
    padding: var(--64);
    padding-bottom: 0;
  }

  @media (max-width: 34ch) {
    article {
      padding: var(--24);
    }
  }

  h1 {
    font-size: var(--font-2xl);
    font-weight: var(--font-bold);
  }

  h2 {
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
  }

  section {
    margin-top: var(--32);
  }

  section p + p {
    margin-top: var(--4);
  }

  p {
    font-size: var(--font-lg);
  }

  .water {
    background-color: rgb(var(--rgb-water));
    flex-grow: 1;
    display: flex;
    align-items: flex-end;
  }

  .cta {
    font-weight: 600;
  }
</style>
