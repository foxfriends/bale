<script>
  const accountName = "foxfriends";
  const name = "Cameron Eldridge";
</script>

<!--
  TODO: This needs to be responsive, but there are no designs for that yet, and no pages on which
  to test this requirement in a reliable way.

  Most likely, as space ceases to suffice:
  * Mush the Bale logotext into the same space as the page title, add a separator, remove the left column
  * Remove the names from the right
  * Switch to mobile style nav by the time that stops working (condensed search, no titles)
-->

<nav>
  <div class="sidebar">
    <a class="title" href="/app">Bale</a>
  </div>
  <div class="page-width">
    <slot />
  </div>
  <div class="sidebar right">
    <div class="profile">
      <div class="info">
        <span class="account">{accountName}</span>
        <span class="name">{name}</span>
      </div>
      <div class="avatar">Turtle</div>
    </div>
  </div>
</nav>

<style>
  nav {
    position: sticky;
    top: 0;
    padding: var(--16);
    background-color: rgb(var(--rgb-grass) / 0.9);
    box-shadow: 0 var(--4) var(--4) rgb(var(--rgb-black) / 0.25);
    backdrop-filter: var(--4);
    display: flex;
    flex-direction: row;
    white-space: nowrap;
  }

  .page-width {
    display: flex;
    flex-grow: 999;
    flex-direction: row;
    justify-content: space-between;
    max-width: var(--width-page);
  }

  .sidebar {
    display: flex;
    flex-basis: 0;
    flex-grow: 1;
  }

  .right {
    justify-content: end;
  }

  .title {
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
  }

  .profile {
    display: flex;
    flex-direction: row;
    gap: var(--16);
  }

  .info {
    display: flex;
    flex-direction: column;
    gap: var(--2);
    align-items: end;
  }

  .account {
    font-weight: var(--font-semibold);
  }

  .name {
    font-size: var(--font-sm);
    color: rgb(var(--rgb-black) / 0.6);
  }

  .avatar {
    width: 64px;
    height: 38px;
    background-color: rgb(var(--rgb-turtle));
    font-size: 8px;
    display: flex;
    align-items: center;
    justify-content: center;
    border-radius: 100%;
  }
</style>
