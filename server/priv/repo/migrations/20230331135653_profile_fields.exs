defmodule Bale.Repo.Migrations.ProfileFields do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :status, :string, null: false, default: ""
      add :bio, :string, null: false, default: ""
    end
  end
end
