<script lang="ts">
  export let style: "error" | "attention" = "attention";
</script>

<div class="blinker">
  <div class="target {style}" />
</div>

<style>
  .blinker {
    position: relative;
    padding: var(--4);
  }

  .target {
    width: var(--8);
    height: var(--8);
    animation: blinker 2s infinite;
    background-color: rgb(var(--blinker-color));
    border-radius: 100%;
  }

  @media (prefers-reduced-motion) {
    .target {
      animation: none;
      box-shadow: 0 0 0 var(--6) rgb(var(--blinker-color) / 0.25);
    }
  }

  .error {
    --blinker-color: var(--rgb-danger);
  }

  .attention {
    --blinker-color: var(--rgb-attention);
  }

  @keyframes blinker {
    from {
      box-shadow: 0 0 0 0 rgb(var(--blinker-color) / 0.75);
    }
    50% {
      box-shadow: 0 0 0 var(--8) rgb(var(--blinker-color) / 0);
    }
    100% {
      box-shadow: 0 0 0 var(--8) rgb(var(--blinker-color) / 0);
    }
  }
</style>
