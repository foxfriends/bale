defmodule Bale.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\""

    create table(:accounts, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false

      timestamps(default: fragment("now()"))
    end

    create unique_index(:accounts, [:name])
  end
end
