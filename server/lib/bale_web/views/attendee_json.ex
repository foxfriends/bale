defmodule BaleWeb.AttendeeJSON do
  def render("one.json", attendee) do
    %{
      account_id: attendee[:account_id],
      event_id: attendee[:event_id],
      state: attendee[:state]
    }
  end
end
