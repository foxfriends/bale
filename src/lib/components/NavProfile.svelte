<script lang="ts">
  import type { Account } from "@prisma/client";

  export let account: Account;
  const name = "Baley McBaleface";
</script>

<a class="profile" href="/app/profile/{account.name}">
  <div class="info">
    <span class="account">{account.name}</span>
    <span class="name">{name}</span>
  </div>
  <div class="avatar">Turtle</div>
</a>

<style>
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
    min-width: 0;
  }

  .account {
    font-weight: var(--font-semibold);
  }

  .name {
    font-size: var(--font-sm);
    color: rgb(var(--rgb-black) / 0.6);
  }

  .account,
  .name {
    min-width: 0;
    max-width: 100%;
    overflow: hidden;
    text-overflow: ellipsis;
    white-space: nowrap;
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
    flex-shrink: 0;
  }
</style>
