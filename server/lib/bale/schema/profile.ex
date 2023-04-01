defmodule Bale.Schema.Profile do
  @moduledoc """
  Schema for profiles, which are distinct from accounts. In fact,
  an account may have no profile, that is ok.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          account_id: Ecto.UUID.t(),
          status: String.t(),
          bio: String.t(),
          photo: String.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :name, :string
    field :status, :string
    field :photo, :string
    field :bio, :string

    belongs_to :account, Bale.Schema.Account
    belongs_to :image, Bale.Schema.Image

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :account_id, :status, :photo, :bio])
    |> check_constraint(:photo, name: :non_empty_photo)
    |> foreign_key_constraint(:account_id)
  end
end
