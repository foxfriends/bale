defmodule BaleWeb.AvatarJSON do
  def render("one.json", avatar) do
    %{
      account_id: avatar[:account_id],
      color: avatar[:color],
      size: avatar[:size]
    }
  end
end
