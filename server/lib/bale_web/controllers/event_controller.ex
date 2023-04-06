defmodule BaleWeb.EventController do
  use BaleWeb, :controller
  alias Bale.Events
  alias Bale.Schema.{Attendee, Event}

  defguardp is_me(conn, account_id) when conn.assigns.account_id == account_id

  def get(conn, %{"event_id" => event_id}) do
    case Events.get_event(event_id) do
      {:not_found, _} -> {:error, :not_found}
      {:ok, event} -> json(conn, Event.to_json(event))
    end
  end

  def create(conn, params) do
    with {:ok, event} <- Events.create_event(conn.assigns[:account_id], params) do
      json(conn, Event.to_json(event))
    end
  end

  def update(conn, %{"event_id" => event_id} = params) do
    with(
      {:ok, event} when is_me(conn, event.host_id) <- Events.get_event(event_id),
      {:ok, updated} <- Events.update_event(event, params)
    ) do
      json(conn, Event.to_json(updated))
    else
      {:ok, _} -> {:error, :forbidden}
      {:not_found, _} -> {:error, :not_found}
      {:error, _} -> {:error, :bad_request}
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update_attendee(conn, %{"event_id" => event_id, "account_id" => account_id} = params)
      when is_me(conn, account_id) do
    with {:ok, attendee} <- Events.update_attendee(account_id, event_id, params) do
      json(conn, Attendee.to_json(attendee))
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update_attendee(_, _), do: {:error, :forbidden}
end
