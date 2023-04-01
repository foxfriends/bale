defmodule BaleWeb.AvatarController do
  use BaleWeb, :controller
  alias Bale.Social

  def get(conn, %{"account_id" => account_id}) do
    case Social.find_avatar(account_id) do
      nil -> {:error, :not_found}
      avatar -> render(conn, :one, Map.from_struct(avatar))
    end
  end

  def create(conn, _) do
    with {:ok, avatar} <- Social.create_avatar(conn.assigns[:account_id]) do
      render(conn, :one, Map.from_struct(avatar))
    end
  end

  def partial_update(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def partial_update(conn, %{"account_id" => account_id} = params) do
    case Social.find_avatar(account_id) do
      nil ->
        {:error, :not_found}

      avatar ->
        with {:ok, updated} <- Social.update_avatar(avatar, params) do
          render(conn, :one, Map.from_struct(updated))
        end
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end
end
