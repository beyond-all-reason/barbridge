defmodule Barbridge.Account.UserLibTests do
  @moduledoc false

  alias Barbridge.Account.User
  alias Barbridge.Account.UserLib
  alias Barbridge.AccountFixtures
  alias Barbridge.DiscordFixtures

  use Barbridge.DataCase, async: true

  describe "create_user/1" do
    test "handles proper attributes" do
      discord_profile = DiscordFixtures.discord_profile_fixture()

      {:ok, %User{} = user} = UserLib.create_user(discord_profile.id)

      assert user.primary_discord_profile_id == discord_profile.id
    end
  end

  describe "update_primary_discord_profile" do
    test "handles proper attributes" do
      user = AccountFixtures.user_fixture()
      new_profile = DiscordFixtures.discord_profile_fixture()

      {:ok, %User{} = user} = UserLib.update_primary_discord_profile(user, new_profile.id)

      assert user.primary_discord_profile_id == new_profile.id
    end
  end

  describe "get_by_id/1" do
    test "handle user exists" do
      user = AccountFixtures.user_fixture()

      queried_user = UserLib.get_by_id(user.id)

      assert queried_user == user
    end

    test "handle user does not exist" do
      user = UserLib.get_by_id(Ecto.UUID.generate())

      assert is_nil(user)
    end
  end

  describe "get_by_discord_id/1" do
    test "handle user exists" do
      discord_profile = DiscordFixtures.discord_profile_fixture()
      user = AccountFixtures.user_fixture(discord_profile.id)

      queried_user = UserLib.get_by_discord_id(discord_profile.id)

      assert queried_user.id == user.id
    end

    test "handle user does not exist" do
      user = UserLib.get_by_discord_id(0)

      assert is_nil(user)
    end
  end

  describe "list_users" do
    test "gives all users" do
      AccountFixtures.user_fixture()
      AccountFixtures.user_fixture()

      assert length(UserLib.list_users()) == 2
    end
  end
end
