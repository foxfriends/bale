defmodule Bale.Account.Password do
  use Ecto.Schema
  import Ecto.Changeset
  alias Bale.Repo

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "passwords" do
    field :password, :string, redact: true

    timestamps()

    belongs_to :account, Bale.Account.Account
  end

  @doc false
  def changeset(password, attrs) do
    password
    |> cast(attrs, [:password, :account_id])
    |> validate_required([:password, :account_id])
  end

  def create(attrs) do
    %__MODULE__{} |> changeset(attrs) |> Repo.insert()
  end
end
