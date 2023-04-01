defmodule Bale.Repo.Migrations.ProfilePhotoImage do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :image_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id)
    end

    create index(:profiles, [:image_id])
  end
end
