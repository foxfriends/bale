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

  alias Bale.Repo
  alias Bale.Schema.Event

  @spec create_event(Ecto.UUID.t()) :: {:ok, Event.t()} | {:error, :conflict}
  def create_event(host_id) do
    %Event{}
    |> Event.changeset(%{host_id: host_id})
    |> Repo.insert()
  end

  @spec update_event(Event.t(), map()) :: {:ok, Event.t()} | {:error, Ecto.Changeset.t()}
  def update_event(event, changes) do
    event
    |> Event.changeset(changes)
    |> Repo.update()
  end

  @spec get_event(Ecto.UUID.t()) :: Event.t() | nil
  def get_event(id) do
    Repo.get(Event, id)
  end
end
