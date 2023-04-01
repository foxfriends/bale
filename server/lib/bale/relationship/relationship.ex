defmodule Bale.Relationship.Relationship do
  @moduledoc """
  Schema to represent a relationship between two accounts. A relationship
  is one-directional, but friendships can be established by sending a
  FriendshipRequest which gets approved; you can't be friends without
  consent.

  You can totally follow someone though; just don't be surprised if
  they block you.
  """

  import Ecto.Query
  import Ecto.Changeset
  use Ecto.Schema
  alias Bale.Repo

  @type level() :: :neutral | :friend | :best_friend | :blocked
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          account_id: Ecto.UUID.t(),
          partner_id: Ecto.UUID.t(),
          level: level(),
          is_following: boolean(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "relationships" do
    field :level, Ecto.Enum, values: [:neutral, :friend, :best_friend, :blocked]
    field :is_following, :boolean
    belongs_to :account, Bale.Account.Account
    belongs_to :partner, Bale.Account.Account

    timestamps()
  end

  def update_changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:level, :is_following, :account_id, :partner_id])
    |> validate_required([:account_id, :partner_id])
  end

  def replace_changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:level, :is_following, :account_id, :partner_id])
    |> validate_required([:level, :is_following, :account_id, :partner_id])
  end

  @spec delete(Ecto.UUID.t(), Ecto.UUID.t()) :: :ok
  def delete(account_id, partner_id) do
    from(r in __MODULE__,
      where: r.account_id == ^account_id and r.partner_id == ^partner_id
    )
    |> Repo.delete_all()
  end
end
