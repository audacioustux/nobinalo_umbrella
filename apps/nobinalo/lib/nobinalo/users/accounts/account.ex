defmodule Nobinalo.Users.Accounts.Account do
  @moduledoc false

  alias __MODULE__

  use Nobinalo.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias Ecto.UUID
  alias Nobinalo.Users
  alias Users.Emails.Email
  alias Users.Profiles.Profile

  @derive {Inspect, except: [:password]}
  @primary_key {:id, UUID, read_after_writes: true}
  schema "accounts" do
    field(:display_name)
    field(:password, :string, virtual: true)
    field(:password_hash)
    field(:is_active, :boolean, default: true)

    belongs_to(:successor, Account)
    belongs_to(:supervisor, Account)

    has_many(:supervisor_of, Account)
    has_many(:successor_of, Account)

    has_one(:profile, Profile)
    has_many(:emails, Email)

    timestamps()
  end

  @doc """
    A account changeset for create
  """
  def register_changeset(account, attrs, id_type) do
    account
    |> cast(attrs, ~w[display_name password]a)
    |> validate_display_name()
    |> validate_password()
    |> foreign_key_constraint(:supervisor)
    |> register_with(id_type)
  end

  defp register_with(changeset, :email) do
    changeset
    |> cast_assoc(:emails,
      with: fn email, attrs ->
        Email.register_changeset(email, attrs)
        |> put_change(:is_primary, true)
      end
    )
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

  def query_active(query \\ Account) do
    query
    |> where([a], a.is_active)
  end
end
