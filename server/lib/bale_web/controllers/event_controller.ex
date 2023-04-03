defmodule BaleWeb.EventController do
  use BaleWeb, :controller
  alias Bale.Events

  def get(conn, %{"event_id" => event_id}) do
    case Events.get_event(event_id) do
      nil -> {:error, :not_found}
      event -> render(conn, :one, Map.from_struct(event))
    end
  end

  def create(conn, params) do
    with {:ok, event} <- Events.create_event(conn.assigns[:account_id], params) do
      render(conn, :one, Map.from_struct(event))
    end
  end

  def partial_update(%{assigns: %{event_id: me}}, %{"event_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def partial_update(conn, %{"event_id" => event_id} = params) do
    case Events.get_event(event_id) do
      nil ->
        {:error, :not_found}

      event ->
        with {:ok, updated} <- Events.update_event(event, params) do
          render(conn, :one, Map.from_struct(updated))
        end
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end
end
