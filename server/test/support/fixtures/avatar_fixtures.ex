defmodule BaleWeb.AvatarFixtures do
  alias Bale.Repo
  alias Bale.Schema.Avatar

  def avatar_fixture(account_id, color \\ 0x00FF00, size \\ 50) do
    Repo.insert(%Avatar{account_id: account_id, color: color, size: size})
  end
end
