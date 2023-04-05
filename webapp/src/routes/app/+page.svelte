<script>
  import { model } from "$lib/store/model";

  const profile = model("profile:@me", { name: "" });
</script>

<svelte:head>
  <title>Bale: For You</title>
</svelte:head>

<h1>Bale App</h1>

<pre>{JSON.stringify($profile)}</pre>

<input type="text" bind:value={$profile.name} name="name" placeholder="Name" />
