defmodule Bale.Schema.Event do
  @moduledoc """
  Schema for events that people may attend. Kind of the core feature
  of the whole app.
  """

  alias Bale.Repo
  use Ecto.Schema
  import Ecto.Changeset
  alias Bale.Schema.Attendee
  import Repo

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          title: String.t(),
          description: String.t(),
          location: String.t(),
          is_public: boolean(),
          is_joinable: boolean(),
          is_subgroupable: boolean(),
          host_id: Ecto.UUID.t(),
          image_id: Ecto.UUID.t() | nil,
          occurs_at: NaiveDateTime.t() | nil,
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "events" do
    field :description, :string
    field :is_joinable, :boolean
    field :is_public, :boolean
    field :is_subgroupable, :boolean
    field :location, :string
    field :occurs_at, :naive_datetime
    field :title, :string

    belongs_to :parent, __MODULE__
    belongs_to :host, Bale.Schema.Account
    belongs_to :image, Bale.Schema.Image

    many_to_many :accounts, Bale.Schema.Account, join_through: Bale.Schema.Attendee
    has_many :attendees, Bale.Schema.Attendee

    timestamps()
  end

  @doc false
  def changeset(event, attrs) do
    event
    |> cast(attrs, [
      :title,
      :description,
      :location,
      :occurs_at,
      :is_public,
      :is_joinable,
      :is_subgroupable,
      :parent_id,
      :image_id
    ])
    |> foreign_key_constraint(:host_id)
    |> foreign_key_constraint(:parent_id)
    |> foreign_key_constraint(:image_id)
  end

  def to_json(event) when not is_loaded(event, :attendees),
    do: event |> Repo.preload(:attendees) |> to_json()

  def to_json(event) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      location: event.location,
      is_public: event.is_public,
      is_joinable: event.is_joinable,
      is_subgroupable: event.is_subgroupable,
      host_id: event.host_id,
      image_id: event.image_id,
      occurs_at: event.occurs_at,
      attendees: event.attendees |> Enum.map(&Attendee.to_json/1)
    }
  end
end
