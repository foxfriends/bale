defmodule Bale.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    create table(:images, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :key, :string, null: false

      timestamps(default: fragment("now()"))
    end

    create unique_index(:images, [:key])
  end
end
