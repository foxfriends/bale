<script lang="ts">
  import { PUBLIC_APP_BASE_URL, PUBLIC_SOCKET_BASE_URL } from "$env/static/public";
  import type { LayoutServerData } from "./$types";
  import { setContext } from "svelte";
  import { createSocket } from "$lib/context/socket";

  export let data: LayoutServerData;

  createSocket(`${PUBLIC_SOCKET_BASE_URL}/api/socket/`, {
    params: {
      identity: data.identity,
    },
  });

  setContext("identity", data.identity);
</script>

<svelte:head>
  <base href={PUBLIC_APP_BASE_URL} />
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
