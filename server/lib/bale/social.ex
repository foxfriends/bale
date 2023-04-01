defmodule Bale.Social do
  @moduledoc """
  Manages tasks related to the social aspects of Bale:
  * Profiles
  * Avatars
  """

  import Ecto.Query
  alias Bale.Repo
  alias Bale.Schema.{Avatar, Profile}

  @spec create_profile(Ecto.UUID.t()) :: {:ok, Profile.t()} | {:error, :conflict}
  def create_profile(account_id) do
    %Profile{}
    |> Profile.changeset(%{account_id: account_id})
    |> Repo.insert()
    |> Repo.detect_conflict(:account_id)
  end

  @spec update_profile(Profile.t(), map()) :: {:ok, Profile.t()} | {:error, Ecto.Changeset.t()}
  def update_profile(profile, changes) do
    profile
    |> Profile.changeset(changes)
    |> Repo.update()
  end

  @spec find_profile(Ecto.UUID.t()) :: Profile.t() | nil
  def find_profile(account_id) do
    Repo.one(from p in Profile, where: p.account_id == ^account_id)
  end

  @spec create_avatar(Ecto.UUID.t()) :: {:ok, Avatar.t()} | {:error, :conflict}
  def create_avatar(account_id) do
    %Avatar{}
    |> Avatar.changeset(%{account_id: account_id})
    |> Repo.insert()
    |> Repo.detect_conflict(:account_id)
  end

  @spec update_avatar(Avatar.t(), map()) :: {:ok, Avatar.t()} | {:error, Ecto.Changeset.t()}
  def update_avatar(avatar, changes) do
    avatar
    |> Avatar.changeset(changes)
    |> Repo.update()
  end

  @spec find_avatar(Ecto.UUID.t()) :: Avatar.t() | nil
  def find_avatar(account_id) do
    Repo.one(from a in Avatar, where: a.account_id == ^account_id)
  end
end
