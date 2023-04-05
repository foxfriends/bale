defmodule BaleWeb.Socket do
  use Phoenix.Socket

  def id(socket), do: "socket:#{socket.assigns.account_id}"

  def connect(%{"identity" => identity}, socket, _) do
    case BaleWeb.IdentityToken.verify_and_validate(identity) do
      {:ok, %{"sub" => account_id}} ->
        socket = assign(socket, :account_id, account_id)
        {:ok, socket}

      {:error, _} ->
        :error
    end
  end

  channel "profile:*", BaleWeb.ProfileChannel
end
