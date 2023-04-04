<script lang="ts">
  import { enhance } from "$app/forms";

  let username = "";
  let password = "";
</script>

<form method="POST" use:enhance>
  <input type="text" name="username" placeholder="Username" bind:value={username} />
  <input type="password" name="password" placeholder="Password" bind:value={password} />
  <button>Sign In</button>
</form>
