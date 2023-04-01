defmodule Bale.Social.Avatar do
  @moduledoc """
  Schema for in-app avatars (not quite profile pictures). The avatar is a turtle
  which the user can customize to represent them, and will be used in many places
  to be cute. The profile photo is only shown on the profile, and is just for
  human identification.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type size() :: 1..100
  @type color() :: integer()
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          account_id: Ecto.UUID.t(),
          color: color(),
          size: size(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "avatars" do
    field :color, :integer
    field :size, :integer

    belongs_to :account, Bale.Account.Account

    timestamps()
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:size, :color, :account_id])
    |> validate_number(:size, greater_than: 0, less_than_or_equal_to: 100)
    |> foreign_key_constraint(:account_id)
  end
end
