# This file is responsible for configuring your application
# and its dependencies with the aid of the Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
import Config

config :bale,
  ecto_repos: [Bale.Repo]

# Configures the endpoint
config :bale, BaleWeb.Endpoint,
  url: [host: "localhost"],
  render_errors: [
    formats: [json: BaleWeb.ErrorJSON],
    layout: false
  ],
  pubsub_server: Bale.PubSub,
  live_view: [signing_salt: "HVp/Xwqu"]

config :bale, Bale.Account, verify_emails: true

config :bale, BaleWeb.IdentityToken,
  issuer: "https://bale.cameldridge.com",
  audience: "https://bale.cameldridge.com"

config :bale, :generators,
  migration: true,
  binary_id: true,
  sample_binary_id: "11111111-1111-1111-1111-111111111111"

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{config_env()}.exs"
