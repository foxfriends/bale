defmodule BaleWeb.ProfileChannel do
  use Phoenix.Channel
  alias Bale.Social
  alias Bale.Schema.Profile

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

  def handle_in("update", %{"body" => body}, socket) do
    profile =
      with {:ok, profile} =
             Social.find_profile(socket.assigns.profile_id) |> Social.update_profile(body) do
        Profile.to_json(profile)
      end

    broadcast!(socket, "update", profile)

    {:reply, :error, socket}
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
