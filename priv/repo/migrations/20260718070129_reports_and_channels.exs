defmodule Barbridge.Repo.Migrations.ReportsAndChannels do
  use Ecto.Migration

  def change do
    create table(:discord_channels, primary_key: false) do
      add :id, :bigint, primary_key: true
      add :name, :integer
      add :function, :integer

      timestamps()
    end

    create table(:discord_profiles, primary_key: false) do
      add :id, :bigint, primary_key: true

      timestamps()
    end

    create table(:users, primary_key: false) do
      add :id, :uuid, primary_key: true
      add :name, :string
      add :primary_discord_profile_id, references(:discord_profiles, on_delete: :nothing)

      timestamps()
    end

    alter table(:discord_profiles) do
      add :user_id, references(:users, on_delete: :nothing, type: :uuid)
    end

    create table(:moderation_reports) do
      add :report_id, :integer
      add :first_report_id, references(:moderation_reports, on_delete: :nothing)

      add :discord_message_id, :bigint
      add :discord_channel_id, references(:discord_channels, on_delete: :nothing)
      # reviewer
      add :reviewer_id, references(:users, on_delete: :nothing, type: :uuid)

      timestamps()
    end
  end
end
