defmodule Bale.Relationship do
  @moduledoc """
  Manages relationships between accounts. All relationships are
  "one directional"; they're really just a form of permissioning
  between accounts.
  """

  alias Bale.Repo
  alias Bale.Schema.Relationship
  import Ecto.Query

  @spec lookup(Ecto.UUID.t(), Ecto.UUID.t()) :: Relationship.t() | nil
  def lookup(account_id, partner_id) do
    Repo.one(
      from(r in Relationship,
        where: r.account_id == ^account_id and r.partner_id == ^partner_id,
        select: r
      )
    )
  end

  @spec upsert(map() | Ecto.Changeset.t()) :: Relationship.t()
  def upsert(changes) do
    updates =
      changes.changes
      |> Enum.filter(fn {key, _} -> key === :level or key === :is_following end)

    Repo.insert!(
      changes,
      on_conflict: [set: updates],
      conflict_target: [:account_id, :partner_id],
      returning: true
    )
  end
end
