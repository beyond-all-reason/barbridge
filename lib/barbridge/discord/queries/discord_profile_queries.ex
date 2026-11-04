defmodule Barbridge.Discord.DiscordProfileQueries do
  @moduledoc false

  alias Barbridge.Discord.DiscordProfile

  use Barbridge.FileMacros, :queries

  @type t :: Query.t()

  @spec discord_profiles() :: t()
  def discord_profiles do
    from(discord_profile in DiscordProfile, as: :discord_profiles)
  end

  @spec where_id(t(), pos_integer()) :: t()
  def where_id(query, id) do
    from discord_profiles in query,
         where: discord_profiles.id == ^id
  end

  @spec where_user_id(t(), Ecto.UUID.t()) :: t()
  def where_user_id(query, user_id) do
    from discord_profiles in query,
         where: discord_profiles.user_id == ^user_id
  end

  @spec order_by_inserted(t(), :asc | :desc) :: t()
  def order_by_inserted(query, direction \\ :asc) do
    if direction == :asc do
      from(discord_profiles in query, order_by: [asc: discord_profiles.inserted_at])
    else
      from(discord_profiles in query, order_by: [desc: discord_profiles.inserted_at])
    end
  end

  @spec order_by_id(t(), :asc | :desc) :: t()
  def order_by_id(query, direction \\ :asc) do
    if direction == :asc do
      from(discord_profiles in query, order_by: [asc: discord_profiles.id])
    else
      from(discord_profiles in query, order_by: [desc: discord_profiles.id])
    end
  end
end
