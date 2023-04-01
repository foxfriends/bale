defmodule BaleWeb.RelationshipController do
  use BaleWeb, :controller
  alias Bale.Relationship

  def get(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def get(conn, %{"account_id" => account_id, "partner_id" => partner_id}) do
    case Relationship.lookup(account_id, partner_id) do
      nil ->
        {:error, :not_found}

      relationship ->
        conn |> render(:one, Map.from_struct(relationship))
    end
  end

  def update(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def update(conn, params) do
    relationship =
      %Relationship.Relationship{}
      |> Relationship.Relationship.replace_changeset(params)
      |> Bale.Relationship.upsert()
      |> Map.from_struct()

    render(conn, :one, relationship)
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def partial_update(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def partial_update(conn, params) do
    relationship =
      %Relationship.Relationship{}
      |> Relationship.Relationship.update_changeset(params)
      |> Relationship.upsert()
      |> Map.from_struct()

    render(conn, :one, relationship)
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end
end
