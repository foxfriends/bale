defmodule Bale.Account.Account do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bale.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "accounts" do
    field :name, :string

    timestamps()

    has_many :passwords, Bale.Account.Password
    has_many :emails, Bale.Account.Email
  end

  @doc false
  def changeset(account, attrs) do
    account
    |> cast(attrs, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
  end

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
