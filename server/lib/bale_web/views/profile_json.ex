defmodule BaleWeb.ProfileJSON do
  def render("one.json", profile) do
    %{
      account_id: profile[:account_id],
      status: profile[:status],
      bio: profile[:bio],
      name: profile[:name],
      photo: profile[:photo]
    }
  end
end
