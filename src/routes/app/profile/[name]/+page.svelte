<script lang="ts">
  import Card from "$lib/components/Card.svelte";
  import LakePage from "$lib/components/LakePage.svelte";
  import PageTitle from "$lib/components/PageTitle.svelte";
  import AlertTriangleIcon from "$lib/components/AlertTriangleIcon.svelte";
  import type { PageData } from "./$types";
  import IconButton from "$lib/components/IconButton.svelte";
  import Tooltip from "$lib/components/Tooltip.svelte";
  import Tip from "$lib/components/Tip.svelte";

  export let data: PageData;
</script>

<LakePage>
  <PageTitle slot="title">
    {data.account.name}
  </PageTitle>

  <div class="prefix">
    <Tooltip>
      <IconButton --tint="rgb(var(--rgb-danger))">
        <AlertTriangleIcon />
      </IconButton>

      <Tip slot="tip">Report Abuse</Tip>
    </Tooltip>
  </div>
  <div class="layout">
    <div class="profile">
      <Card></Card>
    </div>
    <div class="events">
      <Card></Card>
    </div>
    <div class="friends">
      <Card></Card>
    </div>
    <div class="outfits">
      <Card></Card>
    </div>
  </div>
</LakePage>

<style>
  .prefix {
    display: flex;
    align-items: start;
    justify-content: end;
    padding-block: var(--16);
    margin-block-end: var(--64);
  }

  .layout {
    display: grid;
    grid-template:
      "profile profile events"
      "friends outfits outfits";
    gap: var(--16);
  }

  .profile {
    grid-area: profile;
  }

  .events {
    grid-area: events;
  }

  .friends {
    grid-area: friends;
  }

  .outfits {
    grid-area: outfits;
  }
</style>
