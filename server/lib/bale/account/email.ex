defmodule Bale.Account.Email do
  @moduledoc """
  Schema for email addresses attached to accounts. Login is performed
  by username, the emails are just here for contact, marketing, and
  security purposes.
  """

  use Ecto.Schema
  import Ecto.Changeset

  @type t() :: %__MODULE__{
          __meta__: Ecto.Schema.Metadata.t(),
          id: Ecto.UUID.t(),
          email: String.t(),
          is_verified: boolean(),
          account_id: Ecto.UUID.t(),
          inserted_at: NaiveDateTime.t(),
          updated_at: NaiveDateTime.t()
        }

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "emails" do
    field :email, :string
    field :is_verified, :boolean

    timestamps()

    belongs_to :account, Bale.Account.Account
  end

  @doc false
  def changeset(email, attrs) do
    email
    |> cast(attrs, [:email, :account_id, :is_verified])
    |> validate_required([:email, :account_id])
    |> unique_constraint(:email)
  end
end
