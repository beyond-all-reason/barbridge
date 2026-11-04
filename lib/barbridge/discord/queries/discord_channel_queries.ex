defmodule Barbridge.Discord.DiscordChannelQueries do
  @moduledoc false

  alias Barbridge.Discord.DiscordChannel

  use Barbridge.FileMacros, :queries

  @type t :: Query.t()

  @spec discord_channels() :: t()
  def discord_channels do
    from(discord_channels in DiscordChannel, as: :discord_channels)
  end

  @spec where_id(t(), pos_integer()) :: t()
  def where_id(query, id) do
    from discord_channels in query,
         where: discord_channels.id == ^id
  end

  @spec where_function(t(), atom()) :: t()
  def where_function(query, function) do
    from discord_channels in query,
         where: discord_channels.function == ^function
  end

  @spec order_by_inserted(t(), :asc | :desc) :: t()
  def order_by_inserted(query, direction \\ :asc) do
    if direction == :asc do
      from(discord_channels in query, order_by: [asc: discord_channels.inserted_at])
    else
      from(discord_channels in query, order_by: [desc: discord_channels.inserted_at])
    end
  end

  @spec order_by_id(t(), :asc | :desc) :: t()
  def order_by_id(query, direction \\ :asc) do
    if direction == :asc do
      from(discord_channels in query, order_by: [asc: discord_channels.id])
    else
      from(discord_channels in query, order_by: [desc: discord_channels.id])
    end
  end
end
