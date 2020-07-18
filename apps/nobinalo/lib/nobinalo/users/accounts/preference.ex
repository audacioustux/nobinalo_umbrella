defmodule Nobinalo.Users.Accounts.Preference do
  use Ecto.Schema
  import Ecto.Changeset
  alias Nobinalo.Users.Accounts.Preference

  embedded_schema do
    # [left, top, width] where width == height
    field :avatar_cord, {:array, :integer}
    # [left, top, width] where width/height ration: 2.0
    field :cover_cord, {:array, :integer}
  end

  @doc false
  def changeset(%Preference{} = preference, attrs) do
    preference
    |> cast(attrs, [:avatar_cord, :cover_cord])
    |> validate_length(:avatar_cord, is: 3)
    |> validate_length(:cover_cord, is: 3)
  end
end
