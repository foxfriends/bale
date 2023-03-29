defmodule Bale.Repo.Migrations.CreateProfiles do
  use Ecto.Migration

  def change do
    create table(:profiles, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :name, :string, null: false

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create index(:profiles, [:account_id])
  end
end
