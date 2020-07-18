defmodule Nobinalo.Files.Images.Image do
  @moduledoc false

  use Ecto.Schema
  import Ecto.Changeset

  alias Ecto.UUID

  alias Nobinalo.Users.Profiles.Profile
  alias Nobinalo.Files.Images.Type

  @primary_key {:id, UUID, read_after_writes: true}
  schema "images" do
    field :name
    field :width, :integer
    field :height, :integer
    field :checksum, UUID
    field :size, :integer

    field :mime, :string
    field :varient, :string

    embeds_one(:type, Type)

    belongs_to(:profile, Profile, on_replace: :update)

    timestamps()
  end

  @allowed_mime ['image/webp', 'image/jpeg', 'image/gif', 'image/png']

  @optional_fields ~w[checksum]a
  @required_fields ~w[name width height size]a
  @doc false
  def changeset(image, attrs) do
    image
    |> cast(attrs, @optional_fields ++ @required_fields)
    |> validate_required(@required_fields)
    |> validate_inclusion(:mime, @allowed_mime)
    |> cast_assoc(:profile)
    |> validate_extension()
  end

  defp validate_extension(
         %Ecto.Changeset{
           valid?: true,
           changes: %{name: name, mime: mime}
         } = changeset
       ) do
    case MIME.from_path(name) == mime do
      true -> changeset
      false -> add_error(changeset, :name, "extension doesn't match with file type")
    end
  end

  defp validate_extension(changeset), do: changeset
end
