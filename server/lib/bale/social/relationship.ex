defmodule Bale.Social.Relationship do
  @moduledoc """
  Schema to represent a relationship between two accounts. A relationship
  is one-directional, but friendships can be established by sending a
  FriendshipRequest which gets approved; you can't be friends without
  consent.

  You can totally follow someone though; just don't be surprised if
  they block you.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "relationships" do
    field :level, Ecto.Enum, values: [:following, :friend, :blocked]
    belongs_to :account, Bale.Account.Account
    belongs_to :partner, Bale.Account.Account

    timestamps()
  end

  @doc false
  def changeset(relationship, attrs) do
    relationship
    |> cast(attrs, [:level, :account_id, :partner_id])
    |> validate_required([:level, :account_id, :partner_id])
  end
end
