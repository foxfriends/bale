<script context="module" lang="ts">
  import { PUBLIC_BASE_URL } from "$env/static/public";
</script>

<svelte:head>
  <base href={PUBLIC_BASE_URL} />
</svelte:head>

<header />

<main>
  <slot />
</main>

<footer>
  &copy; Bale 2023
  <a href="terms">Terms of Service</a>
  <a href="privacy">Privacy Policy</a>
</footer>
