defmodule Bale.Repo.Migrations.ProfileFields do
  use Ecto.Migration

  def change do
    alter table("profiles") do
      add :status, :string, null: false, default: ""
      add :photo, :string, null: true
      add :bio, :string, null: false, default: ""

      add :avatar_id,
          references(:avatars, on_delete: :nilify_all, on_update: :update_all, type: :binary_id),
          null: true
    end

    create constraint(:profiles, :non_empty_photo, check: "photo <> ''")
  end
end
