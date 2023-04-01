defmodule Bale.Repo.Migrations.CreateAttendees do
  use Ecto.Migration

  def change do
    execute(
      "CREATE TYPE enum_attendee_state AS ENUM('invited', 'bailing', 'undecided', 'attending', 'hosting')",
      "DROP TYPE enum_attendee_state"
    )

    create table(:attendees, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")
      add :state, :enum_attendee_state, null: false

      add :event_id,
          references(:events, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      add :account_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create index(:attendees, [:event_id])
    create index(:attendees, [:account_id])
    create unique_index(:attendees, [:account_id, :event_id])
  end
end
