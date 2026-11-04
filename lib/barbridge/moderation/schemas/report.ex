defmodule Barbridge.Moderation.Report do
  @moduledoc false
  use Barbridge.FileMacros, :schema

  @type id :: pos_integer()

  typed_schema "moderation_reports" do
    field :report_id, :integer
    belongs_to :first_report, Barbridge.Moderation.Report

    field :discord_message_id, :integer
    belongs_to :discord_channel, Barbridge.Discord.DiscordChannel
    belongs_to :reviewer, Barbridge.Account.User, type: Ecto.UUID

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(report, attrs \\ %{}) do
    report
    |> cast(
         attrs,
         ~w(report_id first_report_id discord_message_id discord_channel_id reviewer_id)a
       )
    |> validate_required([
      :report_id,
      :discord_message_id,
      :discord_channel_id
    ])
    |> unique_constraint(:report_id)
    |> unique_constraint(:discord_message_id)
  end
end
