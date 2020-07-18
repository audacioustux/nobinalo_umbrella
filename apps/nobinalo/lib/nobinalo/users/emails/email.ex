defmodule Nobinalo.Users.Emails.Email do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Nobinalo.Repo
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
    |> cast(attrs, ~w[email is_primary is_verified]a)
    |> cast_assoc(:account, required: true)
    |> validate_email()
    |> prepare_changes(&unsafe_validate_constraints/1)
    |> prepare_changes(&validate_constraints/1)
  end

  @multi_primary_err_msg "Multiple primary email address is not allowed."
  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_length(:email, min: 3, max: 255)
    |> validate_format(:email, @email_re, message: "Invalid Email address")
  end

  defp unsafe_validate_constraints(changeset) do
    put_change(changeset, :verified_at, Time.utc_now())

    changeset
    |> unsafe_validate_unique(:email, Repo)
    |> unsafe_validate_unique(:email, Repo,
      name: "primary_email_index",
      message: @multi_primary_err_msg
    )

    unless get_change(changeset, :is_verified) do
      delete_change(changeset, :verified_at)
    end
  end

  defp validate_constraints(%{data: %{is_verified: true}} = changeset) do
    changeset
    |> unique_constraint(:email)
    |> unique_constraint(:email,
      name: "primary_email_index",
      message: @multi_primary_err_msg
    )
  end

  defp validate_constraints(changeset), do: changeset
end
