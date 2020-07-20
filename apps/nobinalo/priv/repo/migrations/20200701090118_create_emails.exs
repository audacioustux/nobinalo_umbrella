defmodule Nobinalo.Repo.Migrations.CreateEmails do
  @moduledoc false

  use Ecto.Migration

  def change do
    execute("CREATE EXTENSION citext", "DROP EXTENSION citext")

    create table(:emails) do
      add :email, :citext, null: false
      add :account_id, references(:accounts, type: :uuid), null: false

      add :is_primary, :boolean, null: false, default: false
      add :is_public, :boolean, null: false, default: false
      add :is_backup, :boolean, null: false, default: false

      add :verified_at, :timestamptz

      timestamps()
    end

    # verified emails must be unique
    create unique_index(:emails, :email,
             where: "verified_at IS NOT NULL",
             name: "emails_verified_unique_email_index"
           )

    # disallow accidental re-submit
    create unique_index(:emails, [:email, :account_id],
             where: "verified_at IS NULL",
             name: "emails_pending_assoc_email_index"
           )

    # foreign key index
    create index(:emails, :account_id)

    # only allow one primary email
    create unique_index(:emails, :account_id,
             where: "is_primary AND verified_at IS NOT NULL",
             name: "emails_primary_unique_email_index"
           )
  end
end
