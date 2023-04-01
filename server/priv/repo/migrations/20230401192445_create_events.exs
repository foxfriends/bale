defmodule Bale.Repo.Migrations.CreateEvents do
  use Ecto.Migration

  def change do
    create table(:events, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :title, :string, null: false
      add :description, :text, null: false, default: ""
      add :location, :string, null: false, default: ""
      add :occurs_at, :naive_datetime, null: false
      add :is_public, :boolean, default: false, null: false

      add :host_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      add :image_id,
          references(:images, on_delete: :delete_all, on_update: :update_all, type: :binary_id)

      timestamps(default: fragment("now()"))
    end

    create index(:events, [:host_id])
    create index(:events, [:image_id])
  end
end
