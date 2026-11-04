defmodule Barbridge.ModerationFixtures do
  alias Barbridge.DiscordFixtures
  alias Barbridge.Moderation.ReportLib

  def report_fixture(attrs \\ %{}) do
    channel = DiscordFixtures.channel_fixture()

    {:ok, report} =
      attrs
      |> Enum.into(%{
        "report_id" => :rand.uniform(1_000_000_000),
        "discord_message_id" => DiscordFixtures.random_snowflake_id(),
        "discord_channel_id" => channel.id
      })
      |> ReportLib.create_report()

    report
  end
end
