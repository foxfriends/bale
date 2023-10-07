import * as kit from "@sveltejs/kit";

type Options = {
  code: string;
  message: string;
  context: unknown;
};

export function error(
  status: number,
  {
    code = "UnknownError",
    message = "An unknown error has occurred",
    context = {},
  }: Partial<Options>,
) {
  return kit.error(status, { code, message, context });
}
