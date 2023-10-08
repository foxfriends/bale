<button on:click {...$$props}>
  <slot />
</button>

<style>
  button {
    display: inline-block;
    border: none;
    background: rgb(var(--rgb-cloud));
    border-radius: calc(var(--44) / 2);
    cursor: pointer;
    height: var(--44);
    width: var(--button-width, var(--phrase));
    font-weight: var(--font-bold);
  }
</style>
