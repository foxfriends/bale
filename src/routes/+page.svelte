<script lang="ts">
  import { fly } from "svelte/transition";
  import { page } from "$app/stores";
  import TextButton from "$lib/components/TextButton.svelte";
  import Input from "$lib/components/Input.svelte";
  import Button from "$lib/components/Button.svelte";
  import Waterline from "$lib/components/Waterline.svelte";
  import Field from "$lib/components/Field.svelte";
  import { prefersReducedMotion } from "$lib/stores/prefersReducedMotion";
  import { enhance } from "$app/forms";
  import type { SubmitFunction } from "./$types";

  let currentForm: "signup" | "signin" =
    $page.error?.context.form === "signin" ? "signin" : "signup";

  let username = "";
  let password = "";
  let email = "";

  let isSubmitting = false;
  const handleForm: SubmitFunction = () => {
    isSubmitting = true;

    return ({ update }) => {
      isSubmitting = false;
      update();
    };
  };

  let loginUsernameError: string | undefined;
  let loginPasswordError: string | undefined;

  $: if (currentForm === "signin") {
    loginUsernameError = undefined;
    loginPasswordError = undefined;

    if ($page.error?.code === "NotFound") {
      if ($page.error.context.model === "Account") {
        loginUsernameError = "We don't know anyone with this username";
      }
      if ($page.error.context.model === "Password") {
        loginPasswordError = "This account doesn't seem to have a password";
      }
    } else if ($page.error?.code === "InvalidCredentials") {
      loginPasswordError = "This is not the correct password";
    }
  }
</script>

<main>
  <div class="fold" />
  <div class="waterline wide">
    <Waterline shape={[8.5, 8, 7, 1, 0, -1]} width={24} flow={$prefersReducedMotion ? 0 : 0.2} />
  </div>
  <div class="waterline narrow">
    <Waterline shape={[1, 2, 1, 2, 2]} width={24} flow={$prefersReducedMotion ? 0 : 0.2} />
  </div>

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

    <footer class="wide">
      <h3>Everyone&apos;s waiting, jump right in</h3>
    </footer>
  </article>

  {#if currentForm === "signin"}
    <aside class="form" transition:fly={{ x: $prefersReducedMotion ? 0 : -48, opacity: 0 }}>
      <div class="switcher left">
        <TextButton on:click={() => (currentForm = "signup")}>&larr; I need an account</TextButton>
      </div>
      <h2>Nice to see you again</h2>
      <form method="POST" action="?/signin" use:enhance={handleForm}>
        <Field error={loginUsernameError}>
          <Input type="text" placeholder="Username" name="username" bind:value={username} />
        </Field>
        <Field error={loginPasswordError}>
          <Input type="password" placeholder="Password" name="password" bind:value={password} />
        </Field>
        <Button active={isSubmitting} error={!!$page.error}>Sign in</Button>
      </form>
      <div class="note">
        <TextButton>I forgot my password...</TextButton>
      </div>
    </aside>
  {/if}
  {#if currentForm === "signup"}
    <aside class="form" transition:fly={{ x: $prefersReducedMotion ? 0 : 48, opacity: 0 }}>
      <div class="switcher right">
        <TextButton on:click={() => (currentForm = "signin")}>
          I&apos;ve been here before &rarr;
        </TextButton>
      </div>
      <h2>What are you waiting for?</h2>
      <form method="POST" action="?/signup" use:enhance={handleForm}>
        <Input type="text" placeholder="Username" name="username" bind:value={username} />
        <Input type="email" placeholder="E-mail" name="email" bind:value={email} />
        <Input type="password" placeholder="Password" name="password" bind:value={password} />
        <Button active={isSubmitting} error={!!$page.error}>Sign Up</Button>
      </form>
      <div class="note">(Don&apos;t worry, everything can be changed)</div>
    </aside>
  {/if}

  <div class="underwater">
    <article class="catch">
      <section class="hook">
        <p>Time is best spent with friends</p>
        <p>You don’t have to do much, it’s just good to be together</p>
      </section>

      <section class="hook">
        <p>Getting everyone together can be hard.</p>
        <p>Sometimes you just have to put something out there and see who comes</p>
        <p>It’s nice to see other people, you don&apos;t always need an occasion</p>
      </section>
    </article>
  </div>
</main>

<style>
  /* Layout */
  main {
    display: grid;
    grid-template-rows: [catch] 1fr [form] auto [fold catch-end] var(--64) [shore] auto;
    grid-template-columns: [catch] 1fr [form] auto;
  }

  .fold {
    grid-column: 1 / -1;
    grid-row: 1 / fold;
    height: 100vh;
  }

  .catch {
    grid-column: catch;
    grid-row: catch / catch-end;
  }

  .form {
    position: sticky;
    top: calc(0px - var(--48));
    grid-column: form;
    grid-row: form;
  }

  .underwater {
    grid-column: 1 / -1;
    grid-row: shore;
    background-color: rgb(var(--rgb-water));
    padding-block: var(--64);
  }

  .waterline {
    grid-column: 1 / -1;
    grid-row: form / shore;
  }

  /* Catch */
  .catch {
    display: flex;
    flex-direction: column;
    align-items: flex-start;
    gap: var(--48);
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
    grid-template-columns: var(--64) [start] 1fr [end] var(--64);
    grid-template-rows: [switcher] auto [header] auto [form] auto [note] auto;
    width: 100%;
    place-self: end;
    padding: var(--96) 0 var(--64) 0;
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
    text-align: start;
  }
  .right {
    align-items: flex-end;
    text-align: end;
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
    width: var(--360);
  }

  .note {
    grid-column: 1 / -1;
    grid-row: note;
    font-size: var(--font-sm);
    font-weight: var(--font-bold);
    text-align: center;
  }

  .narrow {
    display: none;
  }

  @media (max-width: 120ch) {
    h1 {
      font-size: var(--font-xl);
    }

    h2,
    .hook,
    .catch {
      font-size: var(--font-lg);
    }

    .hook,
    header {
      flex-grow: 0;
    }

    .catch {
      margin-inline: auto;
    }

    main {
      grid-template-columns: [catch form] auto;
      grid-template-rows: [catch] 1fr [catch-end form] auto [fold] auto;
    }

    main > * {
      min-width: 0;
    }

    .form {
      grid-template-columns: [start] auto [end];
      padding-inline: var(--24);
      padding-block-end: var(--16);
      margin-inline: auto;
    }

    form,
    .switcher {
      margin-inline: auto;
      width: 100%;
      max-width: var(--360);
    }

    .catch {
      padding: var(--24);
    }

    .narrow {
      display: block;
    }

    .wide {
      display: none;
    }
  }
</style>
