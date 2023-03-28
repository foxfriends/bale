defmodule Bale.Repo do
  use Ecto.Repo,
    otp_app: :bale,
    adapter: Ecto.Adapters.Postgres
end
