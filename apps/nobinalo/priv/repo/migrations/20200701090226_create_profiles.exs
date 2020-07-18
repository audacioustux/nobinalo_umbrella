defmodule Nobinalo.Repo.Migrations.CreateProfiles do
  @moduledoc false

  use Ecto.Migration

  def change do
    execute("CREATE TYPE gender AS ENUM ('male', 'female', 'non-binary')", "DROP TYPE gender")

    create table(:profiles) do
      add :account_id, references(:accounts, type: :uuid), null: false
      add :handle, :string, size: 24
      add :gender, :gender
      add :about, :string

      timestamps()
    end

    create unique_index(:profiles, :account_id)
    create unique_index(:profiles, :handle)
  end
end
