defmodule Barbridge.Discord.DiscordProfileLib do
  @moduledoc false

  alias Barbridge.Account.User
  alias Barbridge.Discord.DiscordProfile
  alias Barbridge.Discord.DiscordProfileQueries
  alias Barbridge.Repo

  @spec create_discord_profile(map) :: {:ok, User} | {:error, Ecto.Changeset.t()}
  def create_discord_profile(attrs \\ %{}) do
    %DiscordProfile{}
    |> DiscordProfile.changeset(attrs)
    |> Repo.insert()
  end

  @spec update_user(DiscordProfile.t(), integer()) ::
          {:ok, DiscordProfile.t()} | {:error, Ecto.Changeset.t()}
  def update_user(%DiscordProfile{} = profile, user_id) do
    profile
    |> DiscordProfile.changeset(%{user_id: user_id})
    |> Repo.update()
  end

  def list_discord_profiles() do
    DiscordProfileQueries.discord_profiles()
    |> Repo.all()
  end

  @spec get_by_id(integer()) :: DiscordProfile.t() | nil
  def get_by_id(discord_profile_id) do
    DiscordProfileQueries.discord_profiles()
    |> DiscordProfileQueries.where_id(discord_profile_id)
    |> Repo.one()
  end

  @spec list_by_user_id(Ecto.UUID.t()) :: [DiscordProfile.t()] | nil
  def list_by_user_id(user_id) do
    DiscordProfileQueries.discord_profiles()
    |> DiscordProfileQueries.where_user_id(user_id)
    |> Repo.all()
  end
end
