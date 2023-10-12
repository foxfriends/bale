<!-- svelte-ignore a11y-missing-attribute -->
<a {...$$props}><slot /></a>

<style>
  a {
    display: inline-block;
    border: none;
    background: none;
    /**
     * Increase the click box without increasing the actual space taken?
     * Feels like a hack but let's roll with it for now.
     **/
    padding: var(--4);
    margin: calc(0px - var(--4));
    cursor: pointer;

    color: color-mix(in oklch, blue 80%, rgb(var(--rgb-water)));
  }

  a:hover {
    text-decoration: underline;
    color: color-mix(in oklch, blue 60%, rgb(var(--rgb-water)));
  }
</style>
