defmodule BaleWeb.RelationshipFixtures do
  alias Bale.Relationship

  def relationship_fixture(account_id, partner_id, level \\ :neutral, is_following \\ true) do
    Relationship.replace_relationship(account_id, partner_id, %{
      level: level,
      is_following: is_following
    })
  end
end
