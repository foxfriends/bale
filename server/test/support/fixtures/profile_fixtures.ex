defmodule BaleWeb.ProfileFixtures do
  alias Bale.Repo
  alias Bale.Schema.Profile

  def profile_fixture(
        account_id,
        name \\ "Testy McTestFace",
        status \\ "Testing",
        bio \\ "",
        image_id \\ nil
      ) do
    Repo.insert(%Profile{
      account_id: account_id,
      name: name,
      status: status,
      bio: bio,
      image_id: image_id
    })
  end
end
