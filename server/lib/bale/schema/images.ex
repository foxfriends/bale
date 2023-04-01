defmodule Bale.Schema.Images do
  @moduledoc """
  Schema for images. Images are stored in some sort of buckets
  under the keys maintained in this table. We can decide where
  those buckets go later, and include the relevant metadata as
  required.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          key: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "images" do
    field :key, :string

    timestamps()
  end

  @doc false
  def changeset(images, attrs) do
    images
    |> cast(attrs, [:key])
    |> validate_required([:key])
    |> unique_constraint(:key)
  end
end
