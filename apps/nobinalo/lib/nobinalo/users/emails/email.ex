defmodule Nobinalo.Users.Emails.Email do
  @moduledoc false

  use Nobinalo.Schema
  import Ecto.Changeset

  alias Nobinalo.Users.Accounts.Account

  # https://html.spec.whatwg.org/multipage/input.html#e-mail-state-(type=email)
  # because fuck rfc5322 -_-
  @email_re ~r/^[a-zA-Z0-9.!#$%&'*+\/=?^_`{|}~-]+@[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?(?:\.[a-zA-Z0-9](?:[a-zA-Z0-9-]{0,61}[a-zA-Z0-9])?)*$/

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

  @multi_primary_err_msg "Multiple primary email address is not allowed."
  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:email, @email_re, message: "Invalid Email address")
  end

  defp validate_verified_email(%{changes: %{is_verified: true}} = changeset) do
    changeset
    |> unique_constraint(:email)
    |> unique_constraint(:email,
      name: "primary_email_index",
      message: @multi_primary_err_msg
    )
    |> put_change(:verified_at, DateTime.utc_now())
  end

  defp validate_verified_email(changeset), do: changeset
end
