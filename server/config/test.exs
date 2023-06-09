import Config

# Configure your database
#
# The MIX_TEST_PARTITION environment variable can be used
# to provide built-in test partitioning in CI environment.
# Run `mix help test` for more information.
config :bale, Bale.Repo,
  username: "bale",
  password: "bale",
  hostname: "localhost",
  database: "bale_test#{System.get_env("MIX_TEST_PARTITION")}",
  pool: Ecto.Adapters.SQL.Sandbox,
  pool_size: 10

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :bale, BaleWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "67lqy0F/GoR6NIPDK6ZewlUnEqG3LUGjQtITK+UR7uu39/vR3A2AJUOhYnrxWtSu",
  server: false

config :bale, Bale.Account, verify_emails: false

config :joken,
  default_signer: [
    signer_alg: "RS256",
    key_pem: File.read!("priv/dev/jwt-rs256.key")
  ]

# Print only warnings and errors during test
config :logger, level: :warning

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
