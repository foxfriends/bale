defmodule Bale.Repo.Migrations.CreateEmails do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext"

    create table(:emails, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :email, :citext, unique: true, null: false
      add :is_verified, :boolean, null: false, default: false

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create unique_index(:emails, [:email])
    create index(:emails, [:account_id])
  end
end
