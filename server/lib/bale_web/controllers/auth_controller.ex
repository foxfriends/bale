defmodule BaleWeb.AuthController do
  use BaleWeb, :controller
  alias Bale.Account

  def sign_up(conn, %{"username" => username, "email" => email, "password" => password}) do
    with({:ok, _} <- Account.create(%{username: username, email: email, password: password})) do
      json(conn, %{ok: true})
    end
  end

  def identify(conn, %{"username" => username, "password" => password}) do
    # NOTE: this is generating identity tokens, not authorization tokens... but we're
    # just going to run with that for a while. proper authorization can come later.
    with {:ok, id} <- Account.authenticate(%{username: username, password: password}) do
      {:ok, token, _claims} = BaleWeb.IdentityToken.generate_and_sign(%{"sub" => id})

      text(conn, token)
    end
  end
end
