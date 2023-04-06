defmodule BaleWeb.EventController do
  use BaleWeb, :controller
  alias Bale.{Events, Repo}

  def get(conn, %{"event_id" => event_id}) do
    case Events.get_event(event_id) do
      nil ->
        {:error, :not_found}

      event ->
        event
        |> Repo.preload(:attendees)
        |> Map.from_struct()
        |> (&render(conn, :one, &1)).()
    end
  end

  def create(conn, params) do
    with {:ok, event} <- Events.create_event(conn.assigns[:account_id], params) do
      event
      |> Repo.preload(:attendees)
      |> Map.from_struct()
      |> (&render(conn, :one, &1)).()
    end
  end

  def update(%{assigns: %{account_id: me}}, %{"host_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def update(conn, %{"event_id" => event_id} = params) do
    case Events.get_event(event_id) do
      nil ->
        {:error, :not_found}

      event ->
        with {:ok, updated} <- Events.update_event(event, params) do
          updated
          |> Repo.preload(:attendees)
          |> Map.from_struct()
          |> (&render(conn, :one, &1)).()
        end
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update_attendee(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def update_attendee(conn, %{"event_id" => event_id, "account_id" => account_id} = params) do
    with {:ok, attendee} <- Events.update_attendee(account_id, event_id, params) do
      conn
      |> put_view(json: BaleWeb.AttendeeJSON)
      |> render(:one, Map.from_struct(attendee))
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end
end
