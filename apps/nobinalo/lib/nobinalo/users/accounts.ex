defmodule Nobinalo.Users.Accounts do
  @moduledoc """
  The Users.Accounts context.
  """

  import Ecto.Query, warn: false
  alias Nobinalo.Repo
  alias Ecto.Multi

  alias Nobinalo.Users.Accounts.Account
  alias Nobinalo.Users.Emails.Email

  @doc """
  Returns the list of accounts.

  ## Examples

      iex> list_accounts()
      [%Account{}, ...]

  """
  def list_accounts do
    Repo.all(Account)
  end

  @doc """
  Gets a single account.

  Raises `Ecto.NoResultsError` if the Account does not exist.

  ## Examples

      iex> get_account!(123)
      %Account{}

      iex> get_account!(456)
      ** (Ecto.NoResultsError)

  """
  def get_account!(id), do: Repo.get!(Account, id)

  def register_account!(attrs \\ %{}) do
    %Account{}
    |> Account.register_changeset(attrs)
    |> Repo.insert!()
  end

  @wrong_credential_msg "Wrong email or password"
  def get_account_by_email_and_password(email, password) do
    email =
      Email.query_verified()
      |> Email.query_email(email)

    account =
      from(e in email,
        join: a in assoc(e, :account),
        select: a
      )

    with account <- Repo.one(account),
         true <- validate_password?(account, password) do
      {:ok, account}
    else
      _ -> {:error, @wrong_credential_msg}
    end
  end

  @doc """
    Verifies the password
  """
  def validate_password?(
        %Account{
          password_hash: password_hash
        },
        password
      ) do
    Argon2.verify_pass(password, password_hash)
  end

  def validate_password?(_, _) do
    Argon2.no_user_verify()
    false
  end
end
