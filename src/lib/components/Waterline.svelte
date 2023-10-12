<script lang="ts">
  import { onMount } from "svelte";

  export let shape: [number, number, ...number[]];
  export let width = 16;
  export let height = 9;
  export let flow = 0;
  export let cycle = 4_000;

  $: waver = 0;

  onMount(() => {
    let cancel = window.requestAnimationFrame(animateWave);

    function animateWave(timestamp: DOMHighResTimeStamp) {
      const t = (timestamp % cycle) - cycle / 2;
      waver = Math.abs((flow * t) / cycle);
      cancel = window.requestAnimationFrame(animateWave);
    }

    return () => window.cancelAnimationFrame(cancel);
  });

  $: curve = shape.slice(1, -1).reduce((curve, point, i, a) => {
    const xc = ((i + 0.5) / a.length) * width;
    const yc = i % 2 === 0 ? point : shape[i];
    const x = ((i + 1) / a.length) * width;
    const y = point + (i % 2 ? waver : -waver);
    return curve + `S${xc} ${yc} ${x} ${y}`;
  }, "");
</script>

<svg class="waterline" viewBox="0 0 {width} {height}" preserveAspectRatio="none">
  <path
    d="
    M0 {shape[0]}
    {curve}
    L{width} {height}
    L0 {height}
    Z"
  />
</svg>

<style>
  .waterline {
    width: 100%;
    height: 100%;
  }

  path {
    fill: rgb(var(--rgb-water));
  }
</style>
