defmodule BaleWeb.RelationshipJSON do
  def render("one.json", relationship) do
    %{
      account_id: relationship[:account_id],
      partner_id: relationship[:partner_id],
      level: relationship[:level],
      is_following: relationship[:is_following]
    }
  end
end
