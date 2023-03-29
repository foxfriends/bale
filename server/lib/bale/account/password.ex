defmodule Bale.Account.Password do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "passwords" do
    field :password, :string, redact: true
    field :account_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(password, attrs) do
    password
    |> cast(attrs, [:password])
    |> validate_required([:password])
  end
end
