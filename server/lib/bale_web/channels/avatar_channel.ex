defmodule BaleWeb.AvatarChannel do
  @moduledoc """
  Channel for a user avatar.
  """

  use Phoenix.Channel
  alias Bale.Schema.Avatar
  alias Bale.Social

  defguardp is_me(socket) when socket.assigns.account_id == socket.assigns.avatar_id

  def join("avatar:@me", param, socket),
    do: join("avatar:" <> socket.assigns.account_id, param, socket)

  def join("avatar:" <> id, _, socket) do
    socket = assign(socket, :avatar_id, id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("update", update, socket) when is_me(socket) do
    Social.find_avatar(socket.assigns.avatar_id)
    |> create_or_update(update)
    |> broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_in("update", _, socket), do: {:reply, :error, socket}

  def handle_info(:after_join, socket) when is_me(socket) do
    Social.find_avatar(socket.assigns.avatar_id)
    |> or_create()
    |> push_update(socket)

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Social.find_avatar(socket.assigns.avatar_id)
    |> push_update(socket)

    {:noreply, socket}
  end

  defp create_or_update({:not_found, avatar_id}, update),
    do: Social.create_avatar(avatar_id, update)

  defp create_or_update({:ok, avatar}, update), do: Social.update_avatar(avatar, update)

  defp or_create(_, params \\ %{})
  defp or_create({:not_found, avatar_id}, params), do: Social.create_avatar(avatar_id, params)
  defp or_create({:ok, avatar}, _), do: {:ok, avatar}

  defp push_update({:ok, avatar}, socket), do: push(socket, "update", Avatar.to_json(avatar))
  defp push_update(_, _), do: :ok

  defp broadcast_update({:ok, avatar}, socket),
    do: broadcast!(socket, "update", Avatar.to_json(avatar))

  defp broadcast_update(_, _), do: :ok
end
