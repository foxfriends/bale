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
    width: 100%;
    max-width: var(--button-width, var(--360));
    font-weight: var(--font-bold);
  }
</style>
