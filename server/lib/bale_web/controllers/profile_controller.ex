defmodule BaleWeb.ProfileController do
  use BaleWeb, :controller
  alias Bale.Social

  def get(conn, %{"account_id" => account_id}) do
    case Social.find_profile(account_id) do
      nil -> {:error, :not_found}
      profile -> render(conn, :one, Map.from_struct(profile))
    end
  end

  def create(conn, _) do
    with {:ok, profile} <- Social.create_profile(conn.assigns[:account_id]) do
      render(conn, :one, Map.from_struct(profile))
    end
  end

  def partial_update(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def partial_update(conn, %{"account_id" => account_id} = params) do
    case Social.find_profile(account_id) do
      nil ->
        {:error, :not_found}

      profile ->
        with {:ok, updated} <- Social.update_profile(profile, params) do
          render(conn, :one, Map.from_struct(updated))
        end
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end
end
