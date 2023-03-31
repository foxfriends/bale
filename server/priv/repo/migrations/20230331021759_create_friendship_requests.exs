defmodule Bale.Repo.Migrations.CreateFriendshipRequests do
  use Ecto.Migration

  def change do
    create table(:friendship_requests, primary_key: false) do
      add :id, :binary_id, primary_key: true, default: fragment("uuid_generate_v4()")

      add :requester_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      add :requestee_id,
          references(:accounts, on_delete: :delete_all, on_update: :update_all, type: :binary_id),
          null: false

      timestamps(default: fragment("now()"))
    end

    create index(:friendship_requests, [:requester_id])
    create index(:friendship_requests, [:requestee_id])

    create unique_index(:friendship_requests, [
             "least(requestee_id, requester_id)",
             "greatest(requestee_id, requester_id)"
           ])

    create constraint(:friendship_requests, :no_friend_with_self,
             check: "requester_id <> requestee_id"
           )
  end
end
