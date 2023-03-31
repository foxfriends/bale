defmodule Bale.Social.Profile do
  @moduledoc """
  Schema for profiles, which are distinct from accounts. In fact,
  an account may have no profile, that is ok.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :name, :string
    field :status, :string
    field :photo, :string
    field :bio, :string

    belongs_to :account, Bale.Account.Account
    belongs_to :avatar, Bale.Social.Avatar

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :account_id, :status, :photo, :bio, :avatar_id])
    |> validate_required([:name, :account_id])
  end
end
