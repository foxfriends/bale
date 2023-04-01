defmodule BaleWeb.RelationshipJSON do
  def render("one.json", relationship) do
    %{
      level: relationship[:level],
      is_following: relationship[:is_following]
    }
  end
end
