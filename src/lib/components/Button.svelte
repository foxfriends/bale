<script lang="ts">
  export let active = false;
  export let error = false;
  export let success = false;
</script>

<button
  on:click
  {...$$restProps}
  data-active={active}
  data-error={!active && error}
  data-success={!active && success}
>
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

  button[data-active="true"] {
    --from-opacity: 0.8;
    --to-opacity: 0.6;
    animation: pulse 1s infinite alternate;
  }

  button[data-error="true"] {
    --from-background-color: color-mix(in srgb, rgb(var(--rgb-danger)) 75%, rgb(var(--rgb-cloud)));
    --to-background-color: rgb(var(--rgb-cloud));
    animation: flash 0.5s forwards;
  }

  button[data-success="true"] {
    --from-background-color: color-mix(in srgb, rgb(var(--rgb-success)) 75%, rgb(var(--rgb-cloud)));
    --to-background-color: rgb(var(--rgb-cloud));
    animation: flash 0.5s forwards;
  }
</style>
