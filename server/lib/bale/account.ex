defmodule Bale.Account do
  @moduledoc """
  Manages tasks related to accounts and authentication:
  * Creation of accounts and logins
  * Validation of logins
  """

  import Ecto.Query
  alias Bale.Repo
  alias Bale.Schema.{Account, Email, Password}

  defp get_env(key) do
    Application.fetch_env!(:bale, __MODULE__) |> Keyword.fetch!(key)
  end

  @spec create(%{username: String.t(), email: String.t(), password: String.t()}) ::
          {:ok, Ecto.UUID.t()}
  def create(%{
        username: username,
        email: email_address,
        password: password_plaintext
      }) do
    password_hash = Bcrypt.hash_pwd_salt(password_plaintext)

    require_email_verification = get_env(:verify_emails)

    Repo.transaction(fn ->
      with(
        {:ok, %Account{id: account_id}} <-
          %Account{}
          |> Account.changeset(%{name: username})
          |> Repo.insert()
          |> Repo.detect_conflict(:name),
        {:ok, _} <-
          %Email{}
          |> Email.changeset(%{
            email: email_address,
            is_verified: not require_email_verification,
            account_id: account_id
          })
          |> Repo.insert()
          |> Repo.detect_conflict(:email),
        {:ok, _} <-
          %Password{}
          |> Password.changeset(%{password: password_hash, account_id: account_id})
          |> Repo.insert()
      ) do
        if require_email_verification do
          # TODO: send an email here
          raise "Unimplemented: mailer is not yet set up"
        end

        account_id
      end
    end)
  end

  @spec authenticate(%{username: String.t(), password: String.t()}) ::
          {:ok, Ecto.UUID.t()} | {:error, :unauthorized}
  def authenticate(%{
        username: username,
        password: password_plaintext
      }) do
    with(
      [id, password_hash] <-
        Repo.one(
          from(a in Account,
            join: p in assoc(a, :passwords),
            where: a.name == ^username,
            order_by: [desc: p.inserted_at],
            limit: 1,
            select: [a.id, p.password]
          )
        ),
      true <- Bcrypt.verify_pass(password_plaintext, password_hash)
    ) do
      {:ok, id}
    else
      _ ->
        Bcrypt.no_user_verify()
        {:error, :unauthorized}

      false ->
        {:error, :unauthorized}
    end
  end
end
