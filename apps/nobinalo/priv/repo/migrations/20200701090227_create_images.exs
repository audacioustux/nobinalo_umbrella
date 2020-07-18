defmodule Nobinalo.Repo.Migrations.CreateImages do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION IF NOT EXISTS \"uuid-ossp\";")

    create table(:images, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v1mc()")
      add :profile_id, references(:profiles), null: false
      add :name, :string, null: false
      add :type, :map, null: false
      add :width, :integer, null: false
      add :height, :integer, null: false
      add :checksum, :uuid
      add :size, :integer, null: false

      timestamps()
    end
  end
end
