defmodule BaleWeb.ProfileChannel do
  @moduledoc """
  Channel for a user profile.
  """

  use Phoenix.Channel
  alias Bale.Schema.Profile
  alias Bale.Social

  defguardp is_me(socket) when socket.assigns.account_id != socket.assigns.profile_id

  def join("profile:@me", param, socket),
    do: join("profile:" <> socket.assigns.account_id, param, socket)

  def join("profile:" <> id, _, socket) do
    socket = assign(socket, :profile_id, id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in("update", update, socket) when is_me(socket) do
    Social.find_profile(socket.assigns.profile_id)
    |> create_or_update(update)
    |> broadcast_update(socket)

    {:noreply, socket}
  end

  def handle_in("update", _, socket), do: {:reply, :error, socket}

  def handle_info(:after_join, socket) when is_me(socket) do
    Social.find_profile(socket.assigns.profile_id)
    |> or_create()
    |> push_update(socket)

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    Social.find_profile(socket.assigns.profile_id)
    |> push_update(socket)

    {:noreply, socket}
  end

  defp create_or_update({:not_found, profile_id}, update),
    do: Social.create_profile(profile_id, update)

  defp create_or_update({:ok, profile}, update), do: Social.update_profile(profile, update)

  defp or_create(_, params \\ %{})
  defp or_create({:not_found, profile_id}, params), do: Social.create_profile(profile_id, params)
  defp or_create({:ok, profile}, _), do: {:ok, profile}

  defp push_update({:ok, profile}, socket), do: push(socket, "update", Profile.to_json(profile))
  defp push_update(_, _), do: :ok

  defp broadcast_update({:ok, profile}, socket),
    do: broadcast!(socket, "update", Profile.to_json(profile))

  defp broadcast_update(_, _), do: :ok
end
