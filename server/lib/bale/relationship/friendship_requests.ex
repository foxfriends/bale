defmodule Bale.Relationship.FriendshipRequests do
  @moduledoc """
  Schema to represent a request for friendship between two accounts.

  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "friendship_requests" do
    belongs_to :requester, Bale.Account.Account
    belongs_to :requestee, Bale.Account.Account

    timestamps()
  end

  @doc false
  def changeset(friendship_requests, attrs) do
    friendship_requests
    |> cast(attrs, [:requester_id, :requestee_id])
    |> validate_required([:requester_id, :requestee_id])
  end
end
