function matchObject(template: Record<string, unknown>, target: Record<string, unknown>): boolean {
  for (const [key, value] of Object.entries(template)) {
    if (typeof value === "function") {
      if (!value(target[key])) return false;
    } else if (value && typeof value === "object") {
      if (!target[key] || typeof target[key] !== "object") return false;
      return matchObject(value as Record<string, unknown>, target[key] as Record<string, unknown>);
    } else if (target[key] !== value) return false;
  }
  return true;
}

export function matchError(code: string, context: unknown, message: string) {
  return (error: App.Error | undefined | null) => {
    if (!error) return null;
    if (error.code !== code) return null;
    if (!context) return message;
    if (!error.context) return null;
    if (typeof error.context !== "object") return null;
    return matchObject(context as Record<string, unknown>, error.context as Record<string, unknown>)
      ? message
      : null;
  };
}
