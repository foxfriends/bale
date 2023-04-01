defmodule Bale.Repo do
  use Ecto.Repo,
    otp_app: :bale,
    adapter: Ecto.Adapters.Postgres

  @spec detect_conflict({:ok, t}) :: {:ok, t} when t: var
  def detect_conflict({:ok, _} = ok), do: ok

  @spec detect_conflict({:error, term()}) :: {:error, :conflict}
  def detect_conflict({:error, _}) do
    # TODO: More accurate detection of unique constraint
    if in_transaction?(), do: rollback(:conflict)
    {:error, :conflict}
  end
end
