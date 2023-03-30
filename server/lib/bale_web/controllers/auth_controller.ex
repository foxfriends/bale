defmodule BaleWeb.AuthController do
  use BaleWeb, :controller
  alias Bale.Account.Auth

  def sign_up(conn, %{"username" => username, "email" => email, "password" => password}) do
    with(
      {:ok, _} <- Auth.create_account(%{username: username, email: email, password: password})
    ) do
      json(conn, %{ok: true})
    end
  end

  def sign_in(conn, %{"username" => username, "password" => password}) do
    with {:ok, id} <- Auth.authenticate(%{username: username, password: password}) do
      conn
      |> put_status(200)
      |> json(%{id: id})
    end
  end
end
