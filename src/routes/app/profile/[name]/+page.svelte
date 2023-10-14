<script lang="ts">
  import LakePage from "$lib/components/LakePage.svelte";
  import PageTitle from "$lib/components/PageTitle.svelte";
  import type { PageData } from "./$types";

  export let data: PageData;
</script>

<LakePage>
  <PageTitle slot="title">
    {data.account.name}
  </PageTitle>

  <pre>{JSON.stringify(data, null, 2)}</pre>
</LakePage>
