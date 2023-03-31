defmodule Bale.Social.Avatar do
  @moduledoc """
  Schema for in-app avatars (not quite profile pictures). The avatar is a turtle
  which the user can customize to represent them, and will be used in many places
  to be cute. The profile photo is only shown on the profile, and is just for
  human identification.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "avatars" do
    field :color, :integer
    field :size, :integer

    has_one :profile, Bale.Social.Profile

    timestamps()
  end

  @doc false
  def changeset(avatar, attrs) do
    avatar
    |> cast(attrs, [:size, :color])
    |> validate_required([:size, :color])
  end
end
