defmodule BaleWeb.EventFixtures do
  alias Bale.Repo
  alias Bale.Schema.Event

  # Clearly this pattern is not scaling
  def event_fixture(
        host_id,
        title \\ "Test Event",
        description \\ "It's going to be tested.",
        location \\ "Home",
        is_public \\ false,
        is_joinable \\ true,
        is_subgroupable \\ false,
        image_id \\ nil,
        occurs_at \\ nil
      ) do
    Repo.insert(%Event{
      host_id: host_id,
      title: title,
      description: description,
      location: location,
      is_public: is_public,
      is_joinable: is_joinable,
      is_subgroupable: is_subgroupable,
      image_id: image_id,
      occurs_at: occurs_at
    })
  end
end
