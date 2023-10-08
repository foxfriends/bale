<button on:click {...$$props}>
  <slot />
</button>

<style>
  button {
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
  }

  button:hover {
    text-decoration: underline;
  }
</style>
