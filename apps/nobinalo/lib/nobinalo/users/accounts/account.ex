defmodule Nobinalo.Users.Accounts.Account do
  @moduledoc false

  alias __MODULE__

  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID
  alias Nobinalo.Users.Profiles.Profile

  @primary_key {:id, UUID, read_after_writes: true}
  schema "accounts" do
    field :display_name
    field :password, :string, virtual: true
    field :password_hash
    field :successor, UUID
    field :supervisor, UUID
    field :is_active, :boolean, default: true

    has_one(:profile, Profile)

    timestamps()
  end

  @doc """
    A account changeset for create
  """
  def create_changeset(account, attrs) do
    account
    |> cast(attrs, ~w[display_name password]a)
    |> validate_display_name()
    |> validate_password()
  end

  defp validate_display_name(changeset) do
    changeset
    |> validate_required(:display_name)
    |> validate_length(:display_name, min: 3, max: 48)
  end

  defp validate_password(changeset) do
    changeset
    |> validate_required(:password)
    |> validate_length(:password, min: 12, max: 80)
    |> prepare_changes(&hash_password/1)
  end

  defp hash_password(changeset) do
    password = get_change(changeset, :password)

    changeset
    |> put_change(:password_hash, Argon2.hash_pwd_salt(password))
    |> delete_change(:password)
  end

  @doc """
    A account changeset for changing the password
  """
  def password_changeset(account, attrs) do
    account
    |> cast(attrs, [:password])
    |> validate_password()
  end

  @doc """
    Verifies the password
  """
  def valid_password?(
        %Account{
          password_hash: password_hash
        },
        password
      )
      when is_binary(password_hash) and byte_size(password) > 0 do
    Argon2.verify_pass(password, password_hash)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  @doc """
  Validate the current password otherwise adds an error to the changeset
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
