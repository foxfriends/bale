defmodule Bale.Repo do
  use Ecto.Repo,
    otp_app: :bale,
    adapter: Ecto.Adapters.Postgres

  @spec detect_conflict({:ok, t}, atom()) :: {:ok, t} when t: var
  @spec detect_conflict({:error, error}, atom()) :: {:error, error} | {:error, :conflict}
        when error: var

  def detect_conflict({:error, %Ecto.Changeset{errors: errors}} = original, field) do
    detect_error(errors, original, field, "has already been taken", :conflict)
  end

  def detect_conflict(other, _), do: other

  @spec detect_missing({:ok, t}, atom()) :: {:ok, t} when t: var
  @spec detect_missing({:error, error}, atom()) :: {:error, error} | {:error, :not_found}
        when error: var

  def detect_missing({:error, %Ecto.Changeset{errors: errors}} = original, field) do
    detect_error(errors, original, field, "does not exist", :not_found)
  end

  def detect_missing(other, _), do: other

  defp detect_error([{field, {message, _}} | _], _, field, message, error_type) do
    if in_transaction?(), do: rollback(error_type)
    {:error, error_type}
  end

  defp detect_error([_ | rest], original, field, message, error_type),
    do: detect_error(rest, original, field, message, error_type)

  defp detect_error([], original, _, _, _), do: original

  defguard is_loaded(schema, field)
           when not is_struct(:erlang.map_get(field, schema), Ecto.Association.NotLoaded)
end
