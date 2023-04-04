<script lang="ts">
  import { PUBLIC_API_BASE_URL } from "$env/static/public";

  let username = "";
  let email = "";
  let password = "";

  let error: object | null = null;

  async function signUp() {
    const response = await fetch(`${PUBLIC_API_BASE_URL}/api/auth/new`, {
      method: "POST",
      headers: { "Content-Type": "application/json" },
      body: JSON.stringify({ username, email, password }),
    });
    if (!response.ok) {
      error = await response.json();
    }
  }
</script>

<svelte:head>
  <title>Bale: Don't bail on your friends</title>
</svelte:head>

<h1>Bale</h1>
<h2>Don't bail on your friends.</h2>

<p>This is a great app. Sign up now!</p>

<input type="text" name="username" placeholder="Username" bind:value={username} />
<input type="email" name="email" placeholder="E-mail" bind:value={email} />
<input type="password" name="password" placeholder="Password" bind:value={password} />
<button on:click={signUp}>Sign Up</button>

{#if error}
  <pre>
    {JSON.stringify(error)}
  </pre>
{/if}

<a href="/sign-in"> Sign In </a>
