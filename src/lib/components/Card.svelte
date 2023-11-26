<article>
  <slot />
</article>

<style>
  article {
    background: rgb(var(--rgb-cloud));
    border-radius: var(--radius-sm);
    box-shadow: 0 var(--4) var(--4) rgb(var(--rgb-black) / 0.25);
    padding: var(--padding, var(--8));
  }
</style>
