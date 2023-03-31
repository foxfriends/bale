defmodule Bale.Repo.Migrations.CreateAvatars do
  use Ecto.Migration

  def change do
    create table(:avatars, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :size, :integer, null: false
      add :color, :integer, null: false

      timestamps(default: fragment("now()"))
    end
  end
end
