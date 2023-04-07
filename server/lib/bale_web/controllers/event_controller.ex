defmodule BaleWeb.EventController do
  use BaleWeb, :controller
  alias Bale.Events
  alias Bale.Schema.{Attendee, Event}

  defguardp is_host(conn, event) when conn.assigns.account_id == event.host_id

  def get(conn, %{"event_id" => event_id}) do
    case Events.find_event(event_id) do
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
      {:ok, event} when is_host(conn, event) <- Events.find_event(event_id),
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

  def rsvp(conn, %{"event_id" => event_id, "state" => state}) do
    with(
      {:ok, event} <- Events.find_event(event_id),
      true <- Events.can_view?(event, conn.assigns.account_id),
      {:ok, attendee} <- Events.rsvp(event, conn.assigns.account_id, state)
    ) do
      json(conn, Attendee.to_json(attendee))
    else
      _ -> {:error, :not_found}
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def invite(conn, %{"event_id" => event_id, "account_id" => account_id}) do
    with(
      {:ok, event} when is_host(conn, event) <- Events.find_event(event_id),
      {:ok, attendee} <- Events.invite(event, account_id)
    ) do
      json(conn, Attendee.to_json(attendee))
    else
      _ -> {:error, :not_found}
    end
  end

  def leave(conn, %{"event_id" => event_id}) do
    with {:ok, event} <- Events.find_event(event_id) do
      Events.leave(event, conn.assigns.account_id)
    end

    conn |> put_status(204)
  end

  def kick(conn, %{"event_id" => event_id, "account_id" => account_id}) do
    with {:ok, event} when is_host(conn, event) <- Events.find_event(event_id) do
      Events.leave(event, account_id)
    end

    conn |> put_status(204)
  end
end
