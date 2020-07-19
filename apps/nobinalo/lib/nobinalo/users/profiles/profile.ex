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

  # TODO: remove @handle_re, validate using changeset
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
    belongs_to(:account, Account, type: UUID)

    timestamps()
  end

  @doc false
  def create_changeset(profile, attrs) do
    profile
    |> cast(attrs, ~w[handle]a)
    |> validate_handle()
    |> cast_assoc(:account, required: true)
  end

  def validate_handle(changeset) do
    changeset
    |> validate_required(:handle)
    |> validate_length(:handle, min: 3, max: 24)
    |> validate_format(:handle, ~r/^(?![_.])/,
      message: ~S["." or "_" not allowed at the beginning]
    )
    |> validate_format(:handle, ~r/(?!.*[_.]{2})/,
      message: ~S["__", "_.", "._", ".." are not allowed]
    )
    |> validate_format(:handle, ~r/(?=.*[a-z])/,
      message: "at-least one alphabet (a-z) must be used"
    )
    |> validate_format(:handle, ~r/[a-z0-9._]+/,
      message: ~S[only alphaneumerics (a-z, 0-9) and ".", "_" are allowed]
    )
    |> validate_format(:handle, ~r/(?<![_.])$/,
      message: ~S["." or "_" not allowed at the end]
    )
    |> validate_exclusion(:handle, @reserved_handles)
    |> unique_constraint(:handle)
  end
end
