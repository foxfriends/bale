defmodule Bale.Account.Account do
  @moduledoc """
  Schema for accounts.

  Contrary to many apps you might find, Bale differentiates between
  accounts, logins, and profiles. An account (as here) is just an
  identifier.
  """

  use Ecto.Schema
  import Ecto.Changeset
  alias Bale.Repo

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          name: String.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string

    timestamps()

    has_many :passwords, Bale.Account.Password
    has_many :emails, Bale.Account.Email
    has_one :profile, Bale.Social.Profile
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

  @spec create(map()) :: {:ok, t()} | {:error, :conflict}
  def create(attrs) do
    # TODO: More accurate (and reusable) detection of unique constraint
    case %__MODULE__{} |> changeset(attrs) |> Repo.insert() do
      {:ok, _} = ok ->
        ok

      {:error, _} ->
        if Repo.in_transaction?(), do: Repo.rollback(:conflict)
        {:error, :conflict}
    end
  end
end
