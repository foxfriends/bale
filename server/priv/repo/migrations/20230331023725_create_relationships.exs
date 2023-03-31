defmodule Bale.Repo.Migrations.CreateRelationships do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE enum_relationship_level AS ENUM('following', 'friend', 'blocked')",
      "DROP TYPE enum_relationship_level"
    )

    create table(:relationships, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :level, :enum_relationship_level, null: false

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      add :partner_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create index(:relationships, [:account_id])
    create index(:relationships, [:partner_id])
    create unique_index(:relationships, [:account_id, :partner_id])
  end
end
