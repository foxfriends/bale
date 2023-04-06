defmodule Bale.Schema.Attendee do
  @moduledoc """
  Schema for the join table between events and the people attending those
  events.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type state() :: :invited | :bailing | :undecided | :attending | :hosting
  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          state: state(),
          account_id: Ecto.UUID.t(),
          event_id: Ecto.UUID.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "attendees" do
    field :state, Ecto.Enum, values: [:invited, :bailing, :undecided, :attending, :hosting]
    belongs_to :event, Bale.Schema.Event
    belongs_to :account, Bale.Schema.Account

    timestamps()
  end

  @doc false
  def changeset(attendee, attrs) do
    attendee
    |> cast(attrs, [:state])
    |> foreign_key_constraint(:account_id)
    |> foreign_key_constraint(:event_id)
  end

  def replacing(changeset) do
    changeset |> validate_required([:state])
  end

  def to_json(attendee) do
    %{
      account_id: attendee.account_id,
      event_id: attendee.event_id,
      state: attendee.state
    }
  end
end
