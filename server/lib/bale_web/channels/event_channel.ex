defmodule BaleWeb.EventChannel do
  @moduledoc """
  Channel for an event.
  """

  use Phoenix.Channel
  alias Bale.Events
  alias Bale.Schema.Event

  defguardp is_me(socket, host_id) when socket.assigns.account_id == host_id
  defguardp is_host(socket, event) when is_me(socket, event.host_id)

  def join("event:new", _, socket) do
    {:ok, event} = Events.create_event(socket.assigns.account_id)
    socket = assign(socket, :event_id, event.id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("event:" <> id, _, socket) do
    with(
      {:ok, event} <- Events.find_event(id),
      true <- Events.can_view?(event, socket.assigns.account_id)
    ) do
      socket = assign(socket, :event_id, id)
      send(self(), :after_join)
      {:ok, socket}
    else
      _ -> {:error, %{detail: "Not Found"}}
    end
  end

  def handle_in("update", update, socket) do
    Events.find_event(socket.assigns.event_id)
    |> update_mine(socket, update)
    |> broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_in(msg, param, socket) do
    case Events.find_event(socket.assigns.event_id) do
      {:ok, event} -> handle_with_event(msg, param, socket, event)
      _ -> {:noreply, socket}
    end
  end

  def handle_with_event("invite", account_id, socket, event) when is_host(socket, event) do
    with {:ok, _} <- Events.invite(event, account_id) do
      broadcast_update(event, socket)
    end

    {:noreply, socket}
  end

  def handle_with_event("leave", _, socket, event) do
    with :ok <- Events.leave(event, socket.assigns.account_id) do
      broadcast_update(event, socket)
    end

    {:noreply, socket}
  end

  def handle_with_event("kick", account_id, socket, event) when is_host(socket, event) do
    with :ok <- Events.leave(event, account_id) do
      broadcast_update(event, socket)
    end

    {:noreply, socket}
  end

  def handle_with_event("rsvp", status, socket, event) do
    with {:ok, _} <- Events.rsvp(event, socket.assigns.account_id, status) do
      broadcast_update(event, socket)
    end

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Events.find_event(socket.assigns.event_id)
    |> try_push_update(socket)

    {:noreply, socket}
  end

  defp update_mine({:ok, event}, socket, update) when is_me(socket, event.host_id),
    do: Events.update_event(event, update)

  defp update_mine(_, _, _), do: :ok

  defp try_push_update({:ok, event}, socket), do: push_update(event, socket)
  defp try_push_update(_, _), do: :ok

  defp push_update(event, socket), do: push(socket, "update", Event.to_json(event))

  defp broadcast_update({:ok, event}, socket),
    do: broadcast!(socket, "update", Event.to_json(event))

  defp broadcast_update(_, _), do: :ok
end
