defmodule Bale.Schema.Profile do
  @moduledoc """
  Schema for profiles, which are distinct from accounts. In fact,
  an account may have no profile, that is ok.
  """

  alias Bale.Repo
  alias Bale.Schema.Image
  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          account_id: Ecto.UUID.t(),
          status: String.t(),
          bio: String.t(),
          image_id: String.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "profiles" do
    field :name, :string, default: ""
    field :status, :string, default: ""
    field :bio, :string, default: ""

    belongs_to :account, Bale.Schema.Account
    belongs_to :image, Bale.Schema.Image

    timestamps()
  end

  @doc false
  def changeset(profile, attrs) do
    profile
    |> cast(attrs, [:name, :status, :image_id, :bio])
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:image_id)
    |> unique_constraint(:account_id)
  end

  @spec to_json(t()) :: map()
  def to_json(profile) do
    profile = profile |> Repo.preload(:image)

    %{
      id: profile.account_id,
      status: profile.status,
      bio: profile.bio,
      image: profile.image |> Image.to_json()
    }
  end
end
