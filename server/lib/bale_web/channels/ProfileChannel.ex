defmodule BaleWeb.ProfileChannel do
  @moduledoc """
  Channel for a user profile.
  """

  use Phoenix.Channel
  alias Bale.Schema.Profile
  alias Bale.Social

  def join("profile:@me", param, socket),
    do: join("profile:" <> socket.assigns.account_id, param, socket)

  def join("profile:" <> id, _, socket) do
    socket = assign(socket, :profile_id, id)
    send(self(), :after_join)
    {:ok, socket}
  end

  def handle_in(
        "update",
        _,
        %{assigns: %{profile_id: profile_id, account_id: account_id}} = socket
      )
      when account_id != profile_id do
    {:reply, :error, socket}
  end

  def handle_in("update", update, socket) do
    updated =
      case Social.find_profile(socket.assigns.profile_id) do
        nil -> Social.create_profile(socket.assigns.profile_id, update)
        profile -> Social.update_profile(profile, update)
      end

    with {:ok, profile} <- updated do
      profile = Profile.to_json(profile)
      broadcast!(socket, "update", profile)
    end

    {:noreply, socket}
  end

  def handle_info(:after_join, socket) do
    profile =
      case Social.find_profile(socket.assigns.profile_id) do
        nil -> %{}
        profile -> Profile.to_json(profile)
      end

    push(socket, "update", profile)

    {:noreply, socket}
  end
end
