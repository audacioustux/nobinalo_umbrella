defmodule Nobinalo.Repo.Migrations.CreateAccounts do
  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION \"uuid-ossp\"", "DROP EXTENSION \"uuid-ossp\"")

    create table(:accounts, primary_key: false) do
      add :id, :uuid, primary_key: true, default: fragment("uuid_generate_v1mc()")
      add :display_name, :string, size: 48, null: false
      add :password_hash, :string

      add :successor, references(:accounts, type: :uuid)
      add :supervisor, references(:accounts, type: :uuid)

      add :is_active, :boolean, default: true, null: false

      timestamps()
    end
  end
end
