defmodule BaleWeb.RelationshipFixtures do
  alias Bale.Relationship

  def relationship_fixture(account_id, partner_id, level \\ :neutral, is_following \\ true) do
    %Relationship.Relationship{}
    |> Relationship.Relationship.replace_changeset(%{
      account_id: account_id,
      partner_id: partner_id,
      level: level,
      is_following: is_following
    })
    |> Relationship.upsert()
  end
end
