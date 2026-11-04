defmodule Barbridge.Discord.DiscordProfileLibTests do
  @moduledoc false

  alias Barbridge.Discord.DiscordProfile
  alias Barbridge.Discord.DiscordProfileLib
  alias Barbridge.AccountFixtures
  alias Barbridge.DiscordFixtures

  use Barbridge.DataCase, async: true

  describe "create_discord_profile/1" do
    test "handles proper attributes" do
      user = AccountFixtures.user_fixture()

      id = DiscordFixtures.random_snowflake_id()

      {:ok, %DiscordProfile{} = profile} =
        DiscordProfileLib.create_discord_profile(%{
          id: id,
          user_id: user.id
        })

      assert profile.id == id
      assert profile.user_id == user.id
    end

    test "handles missing attributes" do
      {status, error_changeset} = DiscordProfileLib.create_discord_profile(%{})

      assert status == :error

      assert error_changeset.errors == [
               id: {"can't be blank", [validation: :required]}
             ]
    end
  end

  describe "update_user/2" do
    test "sets user when not set" do
      user = AccountFixtures.user_fixture()
      discord_profile = DiscordFixtures.discord_profile_fixture()
      {:ok, discord_profile} = DiscordProfileLib.update_user(discord_profile, user.id)

      assert discord_profile.user_id == user.id
    end

    test "updates user when set" do
      user1 = AccountFixtures.user_fixture()
      user2 = AccountFixtures.user_fixture()
      discord_profile = DiscordFixtures.discord_profile_fixture(%{user_id: user1.id})

      assert discord_profile.user_id == user1.id

      {:ok, discord_profile} = DiscordProfileLib.update_user(discord_profile, user2.id)

      assert discord_profile.user_id == user2.id
    end
  end

  describe "list_discord_profiles/0" do
    test "lists all users" do
      DiscordFixtures.discord_profile_fixture()
      DiscordFixtures.discord_profile_fixture()

      assert length(DiscordProfileLib.list_discord_profiles()) == 2
    end

    test "handles no users" do
      assert length(DiscordProfileLib.list_discord_profiles()) == 0
    end
  end

  describe "get_by_id/1" do
    test "gets profile" do
      discord_profile = DiscordFixtures.discord_profile_fixture()

      assert ^discord_profile = DiscordProfileLib.get_by_id(discord_profile.id)
    end

    test "handles user not existing" do
      assert is_nil(DiscordProfileLib.get_by_id(1))
    end
  end

  describe "list_by_user_id/1" do
    test "gets profiles" do
      user = AccountFixtures.user_fixture()
      discord_profile = DiscordFixtures.discord_profile_fixture(%{user_id: user.id})

      assert discord_profile in DiscordProfileLib.list_by_user_id(discord_profile.user_id)
    end

    test "handles user not existing" do
      assert [] == DiscordProfileLib.list_by_user_id(Ecto.UUID.generate())
    end
  end
end
