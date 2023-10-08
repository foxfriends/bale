<div class="hero">
  <div class="above">
    <slot name="above" />
  </div>
  <div class="below">
    <slot name="below" />
  </div>
</div>

<style>
  .hero {
    display: grid;
    grid-template-rows: [top] 100vh [fold] auto [end];
  }

  .above {
    grid-row: top / fold;
  }

  .below {
    grid-row: fold / end;
  }
</style>
