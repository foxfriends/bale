defmodule BaleWeb.FallbackController do
  use Phoenix.Controller, formats: [:json]

  def call(conn, {:error, :bad_request}) do
    conn
    |> put_status(400)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"400")
  end

  def call(conn, {:error, :unauthorized}) do
    conn
    |> put_status(401)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"401")
  end

  def call(conn, {:error, :forbidden}) do
    conn
    |> put_status(403)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"403")
  end

  def call(conn, {:error, :not_found}) do
    conn
    |> put_status(404)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"404")
  end

  def call(conn, {:error, :conflict}) do
    conn
    |> put_status(409)
    |> put_view(json: BaleWeb.ErrorJSON)
    |> render(:"409")
  end
end
