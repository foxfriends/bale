defmodule Bale.Repo do
  use Ecto.Repo,
    otp_app: :bale,
    adapter: Ecto.Adapters.Postgres

  @spec detect_conflict({:ok, t}, atom()) :: {:ok, t} when t: var
  @spec detect_conflict({:error, error}, atom()) :: {:error, error} | {:error, :conflict}
        when error: var

  def detect_conflict({:error, %Ecto.Changeset{errors: errors}} = original, field) do
    detect_conflict(errors, original, field)
  end

  def detect_conflict(other, _), do: other

  defp detect_conflict([{field, _} | _], _, field) do
    if in_transaction?(), do: rollback(:conflict)
    {:error, :conflict}
  end

  defp detect_conflict([_ | rest], original, field), do: detect_conflict(rest, original, field)
  defp detect_conflict([], original, _), do: original
end
