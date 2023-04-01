defmodule Bale.Schema.Event do
  @moduledoc """
  Schema for events that people may attend. Kind of the core feature
  of the whole app.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          title: String.t(),
          description: String.t(),
          location: String.t(),
          is_public: boolean(),
          host_id: Ecto.UUID.t(),
          image_id: Ecto.UUID.t() | nil,
          occurs_at: NaiveDateTime.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :description, :string
    field :is_public, :boolean
    field :location, :string
    field :occurs_at, :naive_datetime
    field :title, :string

    belongs_to :host, Bale.Schema.Account
    belongs_to :image, Bale.Schema.Image

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [:title, :description, :location, :occurs_at, :is_public, :host_id])
    |> validate_required([:title, :description, :location, :occurs_at, :is_public, :host_id])
  end
end
