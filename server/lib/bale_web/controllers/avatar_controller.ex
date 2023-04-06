defmodule BaleWeb.AvatarController do
  use BaleWeb, :controller
  alias Bale.Schema.Avatar
  alias Bale.Social

  defguardp is_me(conn, account_id) when conn.assigns.account_id == account_id

  def get(conn, %{"account_id" => account_id}) do
    case Social.find_avatar(account_id) do
      {:not_found, _} -> {:error, :not_found}
      {:ok, avatar} -> json(conn, Avatar.to_json(avatar))
    end
  end

  def create(conn, params) do
    with {:ok, avatar} <- Social.create_avatar(conn.assigns.account_id, params) do
      json(conn, Avatar.to_json(avatar))
    end
  end

  def update(conn, %{"account_id" => account_id} = params) when is_me(conn, account_id) do
    with(
      {:ok, avatar} <- Social.find_avatar(account_id),
      {:ok, updated} <- Social.update_avatar(avatar, params)
    ) do
      json(conn, Avatar.to_json(updated))
    else
      {:not_found, _} -> {:error, :not_found}
      {:error, _} -> {:error, :bad_request}
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update(_, _), do: {:error, :forbidden}
end
