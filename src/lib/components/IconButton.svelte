<script lang="ts">
</script>

<button on:click {...$$restProps}>
  <slot />
</button>

<style>
  button {
    display: inline-flex;
    border: none;
    background: none;
    cursor: pointer;
    aspect-ratio: 1 / 1;
    align-items: center;
    justify-content: center;
    font-size: var(--24);
  }

  button:hover {
    color: var(
      --highlight,
      color-mix(in srgb, var(--tint, rgb(var(--rgb-turtle))) 85%, rgb(var(--rgb-black)))
    );
  }
</style>
