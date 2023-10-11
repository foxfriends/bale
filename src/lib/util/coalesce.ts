export function coalesce<T, U, V>(
  a: (value: T) => U,
  b: (value: T) => V,
): (value: T) => NonNullable<U> | V {
  return (value: T) => a(value) ?? b(value);
}
