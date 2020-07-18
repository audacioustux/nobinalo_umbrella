defmodule Nobinalo.Users.Emails do
  @moduledoc """
  The Users.Emails context.
  """

  import Ecto.Query, warn: false
  alias Nobinalo.Repo

  alias Nobinalo.Users.Emails.Email
  alias Nobinalo.Users.Accounts.Account
  alias Nobinalo.Users.Guardian

  @doc """
  Returns the list of emails.

  ## Examples

      iex> list_emails()
      [%Email{}, ...]

  """
  def list_emails do
    Repo.all(Email)
  end

  @doc """
  Gets a single email.

  Raises `Ecto.NoResultsError` if the Email does not exist.

  ## Examples

      iex> get_email!(123)
      %Email{}

      iex> get_email!(456)
      ** (Ecto.NoResultsError)

  """
  def get_email!(id), do: Repo.get!(Email, id)

  @doc """
  Creates a Email.

  ## Examples

      iex> create_email(%{field: value})
      {:ok, %Email{}}

      iex> create_email(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_email(attrs \\ %{}) do
    %Email{}
    |> Email.create_changeset(attrs)
    |> Repo.insert()
  end

  def verify_email(attrs \\ %{}) do
  end

  defp verify_email_verification_token() do
  end

  defp gen_email_verification_token(user, email) do
    Guardian.encode_and_sign(user, email, token_type: "verify_email")
  end
end
