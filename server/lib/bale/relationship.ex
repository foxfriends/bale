defmodule Bale.Relationship do
  @moduledoc """
  Manages relationships between accounts. All relationships are
  "one directional"; they're really just a form of permissioning
  between accounts.
  """

  alias Bale.Repo
  alias Bale.Schema.Relationship
  import Ecto.Query

  @spec replace_relationship(Ecto.UUID.t(), Ecto.UUID.t(), map()) ::
          {:ok, Relationship.t()} | {:error, :conflict}
  def replace_relationship(account_id, partner_id, data \\ %{}) do
    %Relationship{account_id: account_id, partner_id: partner_id}
    |> Relationship.changeset(data)
    |> Relationship.replacing()
    |> Repo.insert(
      on_conflict: {:replace, [:level, :is_following]},
      conflict_target: [:account_id, :partner_id],
      returning: true
    )
    |> Repo.detect_conflict(:partner_id)
  end

  @spec update_relationship(Relationship.t(), map()) ::
          {:ok, Relationship.t()} | {:error, Ecto.Changeset.t()}
  def update_relationship(relationship, changes) do
    relationship
    |> Relationship.changeset(changes)
    |> Repo.update()
  end

  @spec find_relationship(Ecto.UUID.t(), Ecto.UUID.t()) ::
          {:ok, Relationship.t()} | {:not_found, Ecto.UUID.t()}
  def find_relationship(account_id, partner_id) do
    case Repo.one(
           from(r in Relationship,
             where: r.account_id == ^account_id and r.partner_id == ^partner_id,
             select: r
           )
         ) do
      nil -> {:not_found, account_id}
      relationship -> {:ok, relationship}
    end
  end
end
