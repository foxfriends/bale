defmodule BaleWeb.RelationshipController do
  use BaleWeb, :controller
  alias Bale.Relationship, as: RelationshipContext
  alias Bale.Schema.Relationship

  defguardp is_me(conn, account_id) when conn.assigns.account_id == account_id

  def get(%{assigns: %{account_id: me}}, %{"account_id" => owner}) when owner != me,
    do: {:error, :forbidden}

  def get(conn, %{"account_id" => account_id, "partner_id" => partner_id}) do
    case RelationshipContext.find_relationship(account_id, partner_id) do
      {:not_found, _} -> {:error, :not_found}
      {:ok, relationship} -> json(conn, Relationship.to_json(relationship))
    end
  end

  def replace(conn, %{"account_id" => account_id, "partner_id" => partner_id} = params)
      when is_me(conn, account_id) do
    case RelationshipContext.replace_relationship(account_id, partner_id, params) do
      {:ok, relationship} -> json(conn, Relationship.to_json(relationship))
      {:error, _} -> {:error, :bad_request}
    end
  end

  def replace(_, _), do: {:error, :forbidden}

  def update(conn, %{"account_id" => account_id, "partner_id" => partner_id} = params)
      when is_me(conn, account_id) do
    with(
      {:ok, relationship} <- RelationshipContext.find_relationship(account_id, partner_id),
      {:ok, updated} <- RelationshipContext.update_relationship(relationship, params)
    ) do
      json(conn, Relationship.to_json(updated))
    else
      {:not_found, _} -> {:error, :not_found}
      {:error, _} -> {:error, :bad_request}
    end
  rescue
    Ecto.InvalidChangesetError -> {:error, :bad_request}
  end

  def update(_, _), do: {:error, :forbidden}
end
