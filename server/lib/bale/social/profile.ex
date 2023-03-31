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

    timestamps()

    belongs_to :account, Bale.Account.Account
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
