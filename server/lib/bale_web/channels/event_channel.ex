defmodule BaleWeb.EventChannel do
  @moduledoc """
  Channel for a event.
  """

  use Phoenix.Channel
  alias Bale.Schema.Event
  alias Bale.Events

  defguardp is_me(socket, host_id) when socket.assigns.account_id == host_id

  def join("event:new", _, socket) do
    {:ok, event} = Events.create_event(socket.assigns.account_id)
    socket = assign(socket, :event_id, event.id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def join("event:" <> id, _, socket) do
    socket = assign(socket, :event_id, id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("update", update, socket) do
    Events.find_event(socket.assigns.event_id)
    |> create_or_update_mine(socket, update)
    |> broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Events.find_event(socket.assigns.event_id)
    |> push_update(socket)

    {:noreply, socket}
  end

  defp create_or_update_mine({:not_found, event_id}, _, update),
    do: Events.create_event(event_id, update)

  defp create_or_update_mine({:ok, event}, socket, update) when is_me(socket, event.host_id),
    do: Events.update_event(event, update)

  defp create_or_update_mine(_, _, _), do: :ok

  defp push_update({:ok, event}, socket), do: push(socket, "update", Event.to_json(event))
  defp push_update(_, _), do: :ok

  defp broadcast_update({:ok, event}, socket),
    do: broadcast!(socket, "update", Event.to_json(event))

  defp broadcast_update(_, _), do: :ok
end
