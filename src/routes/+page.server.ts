import { redirect } from "@sveltejs/kit";
import { compare, hash } from "bcrypt";
import type { Actions } from "./$types";
import { Record, String } from "runtypes";
import { error, notFound } from "$lib/server/response";

const SignInRequestBody = Record({
  username: String,
  password: String,
});

const SignUpRequestBody = Record({
  username: String,
  email: String,
  password: String,
});

export const actions: Actions = {
  signin: async ({ locals }) => {
    const { username, password: plaintext } = await locals.formData(SignInRequestBody);
    const account = await locals.database.account.findUnique({
      where: { name: username },
    });
    if (!account) {
      throw notFound("No account was found with this username", "Account", { form: "signin" });
    }
    const password = await locals.database.password.findFirst({
      where: { accountId: account.id },
      select: { password: true },
      orderBy: { createdAt: "desc" },
    });
    if (!password) {
      throw notFound("No password was found for this account", "Password", { form: "signin" });
    }
    if (!(await compare(plaintext, password.password))) {
      throw error(403, {
        code: "InvalidCredentials",
        message: "That is not the correct password",
        context: { form: "signin" },
      });
    }
    locals.session = { accountId: account.id };
    return redirect(303, "/app");
  },
  signup: async ({ locals }) => {
    const { email, username, password } = await locals.formData(SignUpRequestBody);
  },
};
