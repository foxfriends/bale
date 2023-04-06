defmodule BaleWeb.ProfileController do
  use BaleWeb, :controller
  alias Bale.Schema.Profile
  alias Bale.Social

  defguardp is_me(conn, account_id) when conn.assigns.account_id == account_id

  def get(conn, %{"account_id" => account_id}) do
    case Social.find_profile(account_id) do
      {:not_found, _} -> {:error, :not_found}
      {:ok, profile} -> json(conn, Profile.to_json(profile))
    end
  end

  def create(conn, params) do
    with {:ok, profile} <- Social.create_profile(conn.assigns.account_id, params) do
      json(conn, Profile.to_json(profile))
    end
  end

  def update(conn, %{"account_id" => account_id} = params) when is_me(conn, account_id) do
    with(
      {:ok, profile} <- Social.find_profile(account_id),
      {:ok, updated} <- Social.update_profile(profile, params)
    ) do
      json(conn, Profile.to_json(updated))
    else
      {:not_found, _} -> {:error, :not_found}
      {:error, _} -> {:error, :bad_request}
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update(_, _), do: {:error, :forbidden}
end
