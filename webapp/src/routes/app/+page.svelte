<script>
  import { getContext } from "svelte";
  const socket = getContext("socket");
  const channel = $socket.channel("profile:@me");
  const profile = $channel.on("update");
</script>

<svelte:head>
  <title>Bale: For You</title>
</svelte:head>

<h1>Bale App</h1>

<pre>{JSON.stringify(profile)}</pre>
