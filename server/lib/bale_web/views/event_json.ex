defmodule BaleWeb.EventJSON do
  def render("one.json", event) do
    %{
      id: event.id,
      title: event.title,
      description: event.description,
      location: event.location,
      is_public: event.is_public,
      is_joinable: event.is_joinable,
      is_subgroupable: event.is_subgroupable,
      host_id: event.host_id,
      image_id: event.image_id,
      occurs_at: event.occurs_at,
      attendees: event.attendees |> Enum.map(&BaleWeb.AttendeeJSON.render("one.json", &1))
    }
  end
end
