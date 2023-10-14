<hgroup>
  <h1><slot /></h1>
  {#if $$slots.subtitle}
    <h2><slot name="subtitle" /></h2>
  {/if}
</hgroup>

<style>
  hgroup {
    display: flex;
    flex-direction: row;
    align-items: baseline;
    gap: var(--24);
  }

  h1 {
    font-size: var(--font-xl);
    font-weight: var(--font-bold);
  }

  h2 {
    font-size: var(--font-lg);
    font-weight: var(--font-bold);
  }
</style>
