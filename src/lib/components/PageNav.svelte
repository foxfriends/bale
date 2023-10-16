<script lang="ts">
  import Field from "./Field.svelte";
  import Input from "./Input.svelte";
  import NavProfile from "./NavProfile.svelte";
  import SearchIcon from "./SearchIcon.svelte";
  import type { Account } from "@prisma/client";

  export let account: Account | undefined;
</script>

<nav>
  <a class="logo" href="/app">Bale</a>

  <div class="main">
    <div class="titles"><slot /></div>
    <search>
      <Field icon={SearchIcon}>
        <Input name="search" type="search" placeholder="Search" />
      </Field>
    </search>
  </div>

  {#if account}
    <div class="right">
      <NavProfile {account} />
    </div>
  {/if}
</nav>

<style>
  nav {
    position: sticky;
    top: 0;

    display: grid;
    grid-template-rows: auto;
    grid-template-columns:
      [left-start]
      1fr
      [left-end main-start]
      minmax(auto, var(--width-page))
      [main-end right-start]
      1fr
      [right-end];
    padding: var(--16) 0;
    background-color: rgb(var(--rgb-grass) / 0.9);
    box-shadow: 0 var(--4) var(--4) rgb(var(--rgb-black) / 0.25);
    backdrop-filter: var(--4);
    align-items: end;
    white-space: nowrap;
  }

  .main {
    display: flex;
    flex-direction: row;
    justify-items: space-between;
  }

  .titles {
    display: flex;
    flex-direction: row;
    align-items: end;
    gap: var(--48);
    padding-right: var(--48);
  }

  .logo {
    grid-column: left-start / left-end;
    margin-left: var(--16);
    margin-right: var(--32);
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
    justify-self: start;
  }

  .right {
    justify-self: end;
    grid-column: right-start / right-end;
    padding-right: var(--16);
    padding-left: var(--64);
  }

  search {
    margin-left: auto;
    width: var(--300);
    grid-column: search-start / search-end;
  }
</style>
