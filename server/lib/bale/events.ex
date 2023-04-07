defmodule Bale.Events do
  @moduledoc """
  Manages events, which is really the core of Bale.

  Public events are listed on the "explore" feed for any user to see,
  while private events are invite only.

  Joinable events allow others to join directly; likely the situation
  for most small, one-off events.

  Subgroupable events act as a "parent" event to which others may create
  sub-events and join those instead. Likely to be used by larger-scale
  event organizers, in the situation that this app gets big enough for
  such interest. We'll support the feature anyway for that one kid having
  a big house party while their parents are away.

  A proper capabilities style permission system is a feature to be considered
  later, for now permissions are just those three.
  """

  alias Bale.{Relationship, Repo}
  alias Bale.Schema.{Attendee, Event}
  import Ecto.Query

  @spec is_attendee?(Event.t(), Ecto.UUID.t()) :: boolean()
  def is_attendee?(event, account_id) do
    Repo.exists?(
      from(a in Attendee, where: a.account_id == ^account_id and a.event_id == ^event.id)
    )
  end

  @spec can_view?(Event.t(), Ecto.UUID.t()) :: boolean()

  def can_view?(event, account_id) when event.host_id == account_id, do: true

  def can_view?(event, account_id) when event.is_public do
    is_attendee?(event, account_id) or
      not Relationship.is_blocked_by?(account_id, event.host_id)
  end

  def can_view?(event, account_id) do
    is_attendee?(event, account_id) or
      not Relationship.is_friended_by?(account_id, event.host_id)
  end

  @spec create_event(Ecto.UUID.t(), map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def create_event(host_id, defaults \\ %{}) do
    with(
      {:ok, event} <-
        %Event{host_id: host_id}
        |> Event.changeset(defaults)
        |> Repo.insert(returning: true)
    ) do
      rsvp(event, host_id, :hosting)
      {:ok, event}
    end
  end

  @spec update_event(Event.t(), map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def update_event(event, changes) do
    event
    |> Event.changeset(changes)
    |> Repo.update()
  end

  @spec find_event(Ecto.UUID.t()) :: {:ok, Event.t()} | {:not_found, Ecto.UUID.t()}
  def find_event(id) do
    case Repo.get(Event, id) do
      nil -> {:not_found, id}
      event -> {:ok, event}
    end
  end

  @spec invite(Event.t(), Ecto.UUID.t()) :: {:ok, Attendee.t()} | {:error, :conflict}
  def invite(event, account_id) do
    %Attendee{account_id: account_id, event_id: event.id}
    |> Attendee.changeset(%{state: :invited})
    |> Repo.insert()
    |> Repo.detect_conflict(:account_id)
  end

  @spec rsvp(Event.t(), Ecto.UUID.t(), Attendee.state()) :: {:ok, Attendee.t()}
  def rsvp(event, account_id, state) do
    %Attendee{account_id: account_id, event_id: event.id}
    |> Attendee.changeset(%{state: state})
    |> Repo.insert(
      on_conflict: {:replace, [:state]},
      conflict_target: [:account_id, :event_id],
      returning: true
    )
  end

  @spec leave(Event.t(), Ecto.UUID.t()) :: :ok
  def leave(event, account_id) do
    Repo.delete_all(
      from a in Attendee, where: a.account_id == ^account_id and a.event_id == ^event.id
    )

    :ok
  end
end
