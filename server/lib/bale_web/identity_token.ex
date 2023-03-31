defmodule BaleWeb.IdentityToken do
  @moduledoc """
  JWT generation for use as identity tokens.

  I know this isn't really sufficient for proper safe authorization, but
  until I have time, identification is enough for authorization as well.
  """

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
