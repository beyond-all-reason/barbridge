defmodule Barbridge.AccountFixtures do
  alias Barbridge.Account.UserLib
  alias Barbridge.Discord.DiscordProfileLib
  alias Barbridge.DiscordFixtures

  def user_fixture(discord_profile_id \\ nil) do
    discord_profile =
      DiscordFixtures.discord_profile_fixture()

    {:ok, user} = UserLib.create_user(discord_profile_id || discord_profile.id)

    DiscordProfileLib.update_user(discord_profile, user.id)

    user
  end
end
