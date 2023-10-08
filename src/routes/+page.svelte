<script lang="ts">
  import { fly } from "svelte/transition";
  import TextButton from "$lib/components/TextButton.svelte";
  import Input from "$lib/components/Input.svelte";
  import Button from "$lib/components/Button.svelte";

  let currentForm = "signup";
</script>

<main>
  <div class="fold" />

  <article class="catch">
    <header>
      <h1>Bale</h1>
      <h2>I need a catchphrase for this</h2>
    </header>

    <section class="hook">
      <p>Getting everyone together can be hard.</p>
      <p>Sometimes you just have to put something out there and see who comes</p>
      <p>It’s nice to see other people, you don&apos;t always need an occasion</p>
    </section>

    <footer>
      <h3>Everyone&apos;s waiting, jump right in</h3>
    </footer>
  </article>

  {#if currentForm === "login"}
    <aside class="form" transition:fly={{ x: -48, opacity: 0 }}>
      <div class="switcher left">
        <TextButton on:click={() => (currentForm = "signup")}>&larr; I need an account</TextButton>
      </div>
      <h2>Nice to see you again</h2>
      <form method="POST">
        <Input type="text" placeholder="Username" name="username" />
        <Input type="password" placeholder="Password" name="password" />
        <Button>Sign in</Button>
      </form>
      <div class="note">
        <TextButton>I forgot my password...</TextButton>
      </div>
    </aside>
  {/if}
  {#if currentForm === "signup"}
    <aside class="form" transition:fly={{ x: 48, opacity: 0 }}>
      <div class="switcher right">
        <TextButton on:click={() => (currentForm = "login")}>
          I&apos;ve been here before &rarr;
        </TextButton>
      </div>
      <h2>What are you waiting for?</h2>
      <form method="POST">
        <Input type="text" placeholder="Username" name="username" />
        <Input type="email" placeholder="E-mail" name="email" />
        <Input type="password" placeholder="Password" name="password" />
        <Button>Sign Up</Button>
      </form>
      <div class="note">(Don&apos;t worry, everything can be changed)</div>
    </aside>
  {/if}
</main>

<style>
  /* Layout */
  main {
    overflow-x: hidden;
    display: grid;
    grid-template-rows: [catch] 1fr [form] auto [fold catch-end] auto [end];
    grid-template-columns: [catch] 1fr [form] auto;
  }

  .fold {
    grid-row: 1 / fold;
    height: 100vh;
  }

  .catch {
    grid-column: catch;
    grid-row: catch / catch-end;
  }

  .form {
    grid-column: form;
    grid-row: form;
  }

  /* Catch */
  .catch {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: var(--64);
    padding: var(--64);
    max-width: var(--narrow);
    font-size: var(--font-xl);
  }

  h1 {
    font-size: var(--font-2xl);
    font-weight: var(--font-bold);
  }

  h2,
  h3,
  .hook {
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
  }

  header {
    flex-grow: 1;
  }

  .hook {
    display: flex;
    flex-direction: column;
    gap: var(--16);
    flex-grow: 3;
  }

  footer {
    margin-top: auto;
  }

  /* Form */

  .form {
    overflow-x: visible;
    display: grid;
    grid-template-columns: var(--64) [start] auto [end] var(--64);
    grid-template-rows: [switcher] auto [header] auto [form] auto [note] auto;
    place-self: end;
    padding-bottom: var(--64);
  }

  .switcher {
    grid-column: start / end;
    grid-row: switcher;
    display: flex;
    flex-direction: column;
    padding-bottom: var(--8);
    font-size: var(--font-sm);
    font-weight: var(--font-bold);
  }
  .left {
    align-items: flex-start;
  }
  .right {
    align-items: flex-end;
  }

  .form h2 {
    grid-column: 1 / -1;
    grid-row: header;
    text-align: center;
  }

  form {
    grid-column: start / end;
    grid-row: form;
    display: flex;
    flex-direction: column;
    gap: var(--24);
    padding-top: var(--24);
    padding-bottom: var(--8);
  }

  .note {
    grid-column: 1 / -1;
    grid-row: note;
    font-size: var(--font-sm);
    font-weight: var(--font-bold);
    text-align: center;
  }

  @media (max-width: 120ch) {
    article {
      padding: var(--48);
    }

    h1 {
      font-size: var(--font-xl);
    }

    h2 {
      font-size: var(--font-lg);
    }

    .hook,
    footer {
      display: none;
    }

    main {
      grid-template-columns: [catch form] auto;
      grid-template-rows: [catch] 1fr [form] auto [fold];
    }
  }
</style>
