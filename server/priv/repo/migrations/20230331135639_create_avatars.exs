defmodule Bale.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :size, :integer, null: false
      add :color, :integer, null: false

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create unique_index(:avatars, [:account_id])
  end
end
