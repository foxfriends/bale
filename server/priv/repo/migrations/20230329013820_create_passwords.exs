defmodule Bale.Repo.Migrations.CreatePasswords do
  use Ecto.Migration

  def change do
    create table(:passwords, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :password, :char, null: false, size: 60

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create index(:passwords, [:account_id])
  end
end
