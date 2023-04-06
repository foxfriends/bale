defmodule Bale.Schema.Relationship do
  @moduledoc """
  Schema to represent a relationship between two accounts. A relationship
  is one-directional, but friendships can be established by sending a
  FriendshipRequest which gets approved; you can't be friends without
  consent.

  You can totally follow someone though; just don't be surprised if
  they block you.
  """

  import Ecto.Changeset
  use Ecto.Schema

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
    belongs_to :account, Bale.Schema.Account
    belongs_to :partner, Bale.Schema.Account

    timestamps()
  end

  def changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:level, :is_following])
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:partner_id)
    |> unique_constraint([:account_id, :partner_id], error_key: :partner_id)
  end

  def replacing(changeset) do
    changeset |> validate_required([:level, :is_following])
  end

  def to_json(relationship) do
    %{
      account_id: relationship.account_id,
      partner_id: relationship.partner_id,
      level: relationship.level,
      is_following: relationship.is_following
    }
  end
end
