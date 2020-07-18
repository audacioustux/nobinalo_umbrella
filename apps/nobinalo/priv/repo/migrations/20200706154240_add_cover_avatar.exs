defmodule Nobinalo.Repo.Migrations.AddCoverAvatar do
  use Ecto.Migration

  def change do
    alter table(:profiles) do
      add :avatar_id, references(:images, type: :uuid)
      add :cover_id, references(:images, type: :uuid)
      add :preferences, :map, default: "{}", null: false
    end
  end
end
