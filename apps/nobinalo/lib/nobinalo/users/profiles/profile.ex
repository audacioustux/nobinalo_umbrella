defmodule Nobinalo.Users.Profiles.Profile do
  @moduledoc false

  use Nobinalo.Schema
  import Ecto.Changeset

  alias Nobinalo.Files.Images.Image
  alias Nobinalo.Users.Accounts.Account
  alias Nobinalo.Users.Accounts.Preference
  alias Ecto.UUID

  @handle_re ~r/^(?![_.])(?!.*[_.]{2})(?=.*[a-z])[a-z0-9._]+(?<![_.])$/
  # (?![_.]) = no _ or . at the beginning
  # (?!.*[_.]{2}) = no __ or _. or ._ or .. inside
  # (?=.*[a-z]) = at least one alphabet
  # [a-z0-9._]+ = allowed characters
  # (?<![_.]) = no _ or . at the end

  @reserved_handles File.read!("priv/reserved_words.json")
                    |> Jason.decode!()
                    |> Enum.filter(&Regex.match?(@handle_re, &1))
                    |> MapSet.new()

  schema "profiles" do
    field :handle
    field :gender
    field :about

    embeds_one :preferences, Preference, on_replace: :update

    belongs_to(:avatar, Image, type: UUID, on_replace: :nilify)
    belongs_to(:cover, Image, type: UUID, on_replace: :nilify)
    belongs_to(:account, Account, type: UUID, on_replace: :update)

    timestamps()
  end

  @optional_fields ~w[gender about]a
  @required_fields ~w[handle account]a
  @doc false
  def create_changeset(profile, attrs) do
    profile
    |> cast(attrs, @optional_fields)
    |> validate_required(@required_fields)
    |> cast_assoc(:account)
    |> cast_assoc(:avatar)
    |> cast_assoc(:cover)
    |> cast_embed(:preferences)
    |> validate_length(:handle, min: 3, max: 24)
    |> validate_format(:handle, @handle_re)
    |> validate_exclusion(:handle, @reserved_handles)
    |> unique_constraint(:handle)
  end
end
