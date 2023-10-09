export function scrollOffset(element: HTMLElement | null) {
  let x = 0;
  let y = 0;
  for (; element; element = element?.parentElement) {
    x += element.scrollLeft;
    y += element.scrollTop;
  }
  return { x, y };
}
