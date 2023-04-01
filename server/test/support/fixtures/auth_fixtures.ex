defmodule BaleWeb.AuthFixtures do
  alias Bale.Account
  import Plug.Conn

  def account_fixture(name \\ "test", email \\ "test@example.com", password \\ "test123") do
    Account.create(%{username: name, email: email, password: password})
  end

  def auth_as(conn, id) do
    {:ok, token, _} = BaleWeb.IdentityToken.generate_and_sign(%{"sub" => id})
    put_req_header(conn, "authorization", "Bearer #{token}")
  end
end
