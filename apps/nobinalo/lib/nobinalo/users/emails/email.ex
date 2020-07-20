defmodule Nobinalo.Users.Emails.Email do
  @moduledoc false

  alias __MODULE__

  use Nobinalo.Schema

  import Ecto.Query
  import Ecto.Changeset
  alias Nobinalo.Users.Guardian

  alias Nobinalo.Users.Accounts.Account

  # https://html.spec.whatwg.org/multipage/input.html#e-mail-state-(type=email)
  # because fuck rfc5322 -_-
  @email_re ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

  @derive {Inspect, except: [:is_verified]}
  schema "emails" do
    field :email
    field :is_primary, :boolean
    field :is_public, :boolean
    field :is_backup, :boolean

    field :verified_at, :utc_datetime_usec
    field :is_verified, :boolean, virtual: true, default: false

    belongs_to(:account, Account, type: Ecto.UUID, on_replace: :update)

    timestamps()
  end

  @doc false
  def create_changeset(email, attrs) do
    email
    |> cast(attrs, ~w[email is_primary is_verified account_id]a)
    |> foreign_key_constraint(:account_id)
    |> validate_email()
    |> prepare_changes(&validate_verified_email/1)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:email, @email_re, message: "invalid Email address")
  end

  defp validate_verified_email(%{changes: %{is_verified: true}} = changeset) do
    changeset
    |> unique_constraint(:email)
    |> unique_constraint(:email,
      name: "primary_email_index",
      message: "multiple primary email address is not allowed."
    )
    |> put_change(:verified_at, DateTime.utc_now())
  end

  defp validate_verified_email(changeset), do: changeset

  def set_verified_changeset(email),
    do: change(email, verified_at: DateTime.utc_now())

  def query_email(query \\ Email, email) do
    query
    |> where([e], e.email == ^email)
  end

  def query_account_id(query \\ Email, account_id) do
    query
    |> where([e], e.account_id == ^account_id)
  end

  def query_verified(query \\ Email) do
    query
    |> where([e], not is_nil(e.verified_at))
  end

  def query_unverified(query \\ Email) do
    query
    |> where([e], is_nil(e.verified_at))
  end

  def get_unverified_by_token_query(token) do
    case Guardian.decode_and_verify(token, %{"typ" => "verify_email"}) do
      {:ok, %{"sub" => account_id, "email" => email}} ->
        query =
          Email.query_unverified()
          |> Email.query_email(email)
          |> Email.query_account_id(account_id)

        {:ok, query}

      {:error, _} ->
        {:error, "invalid token"}
    end
  end
end
