defmodule BaleWeb.Identity do
  @moduledoc """
  Plug to detect the current caller's identity (account_id). The identity is
  extracted from the Authorization header, which should be a "Bearer" token
  containing a JWT from `BaleWeb.IdentityToken`.

  If the request is authenticated correctly, the `:account_id` is added to
  the assigns. If not, the request is unauthorized.
  """
  @behaviour Plug
  import Plug.Conn

  @impl true
  def init(opts) do
    opts
  end

  @spec bearer_token(String.t()) :: String.t() | nil
  @spec bearer_token(nil) :: nil
  defp bearer_token("Bearer " <> token), do: token
  defp bearer_token(_), do: nil

  @impl true
  def call(conn, _opts) do
    with(
      header when is_binary(header) <-
        conn
        |> get_req_header("authorization")
        |> List.first(),
      token when is_binary(token) <- bearer_token(header),
      {:ok, %{"sub" => account_id}} <- BaleWeb.IdentityToken.verify_and_validate(token)
    ) do
      assign(conn, :account_id, account_id)
    else
      _ ->
        conn
        |> BaleWeb.FallbackController.call({:error, :unauthorized})
        |> halt()
    end
  end
end
