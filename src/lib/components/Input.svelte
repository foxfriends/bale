<script lang="ts">
  export let value: string = "";
</script>

<input {...$$props} bind:value />

<style>
  input {
    background-color: rgb(var(--rgb-cloud));
    padding: 0 var(--8);
    color: rgb(var(--rgb-black));
    height: var(--44);
    width: 100%;
    max-width: var(--input-width, var(--360));
    font-size: var(--font-base);
    font-weight: var(--font-bold);
    border-radius: var(--radius-sm);
    border: none;
    /**
     * NOTE: outline has been moved to the surrounding <Field>.
     * All inputs should be within a field anyway.
     */
    outline: none;
  }
</style>
