defmodule BaleWeb.IdentityToken do
  use Joken.Config

  defp get_env(key) do
    Application.fetch_env!(:bale, __MODULE__) |> Keyword.fetch!(key)
  end

  def token_config do
    default_claims(
      aud: get_env(:audience),
      iss: get_env(:issuer),
      # one week
      default_exp: 60 * 60 * 24 * 7
    )
  end
end
