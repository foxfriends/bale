import { json, redirect } from "@sveltejs/kit";
import { compare, hash } from "bcrypt";
import { Record, String } from "runtypes";
import { error, notFound } from "$lib/server/response";
import type { Actions } from "./$types";
import { PrismaClientKnownRequestError } from "@prisma/client/runtime/library";

const SignInRequestBody = Record({
  username: String,
  password: String,
});

const SignUpRequestBody = Record({
  username: String.withConstraint((s) => s !== "" || "ConstraintNotEmpty"),
  email: String.withConstraint((s) => s !== "" || "ConstraintNotEmpty"),
  password: String.withConstraint((s) => s !== "" || "ConstraintNotEmpty"),
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
    throw redirect(303, "/app");
  },
  signup: async ({ locals }) => {
    const { email, username, password: plaintext } = await locals.formData(SignUpRequestBody);
    const password = await hash(plaintext, 10);
    try {
      const account = await locals.database.account.create({
        data: {
          name: username,
          emails: { create: { email } },
          passwords: { create: { password } },
        },
        select: { id: true, name: true },
      });
      locals.session = { accountId: account.id };
      throw redirect(303, "/app");
    } catch (err) {
      if (err instanceof PrismaClientKnownRequestError) {
        if (err.code === "P2002") {
          // Unique constraint error
          if (err.meta && Array.isArray(err.meta?.target)) {
            if (err.meta.target.includes("name")) {
              throw error(409, {
                code: "AccountExists",
                message: "This username is already in use",
                context: { username },
              });
            }
            if (err.meta.target.includes("email")) {
              throw error(409, {
                code: "AccountExists",
                message: "This email is already in use",
                context: { email },
              });
            }
          }
          throw error(409, {
            code: "AccountExists",
            message: "An account already exists with this username or email",
            context: { email, username },
          });
          locals.logger.error(err, "Failed to create account");
        }
      }
      throw err;
    }
  },
};
