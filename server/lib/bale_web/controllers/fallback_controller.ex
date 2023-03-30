defmodule BaleWeb.FallbackController do
  use Phoenix.Controller, formats: [:json]

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(403)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"403")
  end

  def call(conn, {:error, :conflict}) do
    conn
    |> put_status(409)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"409")
  end
end
