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
  <div class="titles">
    <slot />
  </div>
  <search>
    <Field icon={SearchIcon}>
      <Input name="search" type="search" placeholder="Search" />
    </Field>
  </search>

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
    grid-row: nav-start / nav-end;
    grid-column: left-start / right-end;

    display: grid;
    grid-template-columns: subgrid;
    padding: var(--16) 0;
    background-color: rgb(var(--rgb-grass) / 0.9);
    box-shadow: 0 var(--4) var(--4) rgb(var(--rgb-black) / 0.25);
    backdrop-filter: var(--4);
    align-items: end;
    white-space: nowrap;
  }

  .titles {
    display: flex;
    flex-direction: row;
    align-items: end;
    justify-content: space-between;
    grid-row: 1;
    gap: var(--48);
    margin-right: var(--48);
    grid-column: main-start / search-start;
  }

  .logo {
    grid-row: 1;
    grid-column: left-start / left-end;
    margin-left: var(--16);
    margin-right: var(--32);
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
    justify-self: start;
  }

  .right {
    container-type: inline-size;
    display: flex;
    grid-row: 1;
    grid-column: right-start / right-end;
    margin-right: var(--16);
    margin-left: var(--64);
    min-width: 64px;
  }

  search {
    grid-row: 1;
    margin-left: auto;
    width: var(--300);
    grid-column: search-start / search-end;
  }
</style>
