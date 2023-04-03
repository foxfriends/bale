defmodule BaleWeb.ProfileJSON do
  def render("one.json", profile) do
    %{
      account_id: profile[:account_id],
      status: profile[:status],
      bio: profile[:bio],
      name: profile[:name],
      image_id: profile[:image_id]
    }
  end
end
