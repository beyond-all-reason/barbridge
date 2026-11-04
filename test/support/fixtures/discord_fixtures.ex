defmodule Barbridge.DiscordFixtures do
  alias Barbridge.Discord.DiscordChannelLib
  alias Barbridge.Discord.DiscordProfileLib

  def channel_fixture(attrs \\ %{}) do
    {:ok, channel} =
      attrs
      |> Enum.into(%{
        id: random_snowflake_id(),
        function: :post_chat_reports
      })
      |> DiscordChannelLib.create_discord_channel()

    channel
  end

  def discord_profile_fixture(attrs \\ %{}) do
    {:ok, discord_profile} =
      attrs
      |> Enum.into(%{
        id: random_snowflake_id()
      })
      |> DiscordProfileLib.create_discord_profile()

    discord_profile
  end

  def random_snowflake_id() do
    1_000_000_000_000_000_000 + :rand.uniform(1_000_000_000_000_000_000)
  end
end
