defmodule Barbridge.Discord.DiscordChannelLib do
  @moduledoc false

  alias Nostrum.Api.Channel
  alias Nostrum.Api.Interaction
  alias Nostrum.Api.Message
  alias Nostrum.Api.User, as: NostrumUser
  alias Barbridge.Discord.DiscordChannel
  alias Barbridge.Discord.DiscordChannelQueries

  use Barbridge.FileMacros, :library_newform

  @doc """
  Returns the list of discord_channels.

  ## Examples

      iex> list_discord_channels()
      [%DiscordChannel{}, ...]

  """
  @spec list_discord_channels() :: list
  def list_discord_channels() do
    DiscordChannelQueries.discord_channels()
    |> Repo.all()
  end

  @doc """
  Gets a single discord_channel.

  Raises `Ecto.NoResultsError` if the DiscordChannel does not exist.

  ## Examples

      iex> get_discord_channel!(123)
      %DiscordChannel{}

      iex> get_discord_channel!(456)
      ** (Ecto.NoResultsError)

  """
  @spec get_discord_channel!(non_neg_integer()) :: DiscordChannel.t()
  def get_discord_channel!(discord_channel_id) do
    DiscordChannelQueries.discord_channels()
    |> DiscordChannelQueries.where_id(discord_channel_id)
    |> Repo.one!()
  end

  @spec get_discord_channel(non_neg_integer() | String.t()) :: DiscordChannel.t() | nil
  def get_discord_channel(discord_channel_id) when is_integer(discord_channel_id) do
    DiscordChannelQueries.discord_channels()
    |> DiscordChannelQueries.where_id(discord_channel_id)
    |> Repo.one()
  end

  @doc """
  Creates a discord_channel.

  ## Examples

      iex> create_discord_channel(%{field: value})
      {:ok, %DiscordChannel{}}

      iex> create_discord_channel(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_discord_channel(attrs \\ %{}) do
    %DiscordChannel{}
    |> DiscordChannel.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a discord_channel.

  ## Examples

      iex> update_discord_channel(discord_channel, %{field: new_value})
      {:ok, %DiscordChannel{}}

      iex> update_discord_channel(discord_channel, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_discord_channel(%DiscordChannel{} = discord_channel, attrs) do
    discord_channel
    |> DiscordChannel.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a discord_channel.

  ## Examples

      iex> delete_discord_channel(discord_channel)
      {:ok, %DiscordChannel{}}

      iex> delete_discord_channel(discord_channel)
      {:error, %Ecto.Changeset{}}

  """
  def delete_discord_channel(%DiscordChannel{} = discord_channel) do
    Repo.delete(discord_channel)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking discord_channel changes.

  ## Examples

      iex> change_discord_channel(discord_channel)
      %Ecto.Changeset{data: %DiscordChannel{}}

  """
  def change_discord_channel(%DiscordChannel{} = discord_channel, attrs \\ %{}) do
    DiscordChannel.changeset(discord_channel, attrs)
  end

  @doc """
  Given an integer it will take use the channel id, if given a string it will look up
  the channel name from the database Barbridge.Communication.DiscordChannel objects
  """
  @spec new_discord_message(String.t() | non_neg_integer(), String.t()) ::
          {:ok, Nostrum.Struct.Message.t()} | {:error, any}
  def new_discord_message(maybe_channel_id, message) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil -> {:error, "No channel found"}
      channel_id -> Message.create(channel_id, message)
    end
  end

  @spec rename_discord_channel(String.t() | non_neg_integer(), String.t()) ::
          {:ok, Nostrum.Struct.Message.t()} | {:error, any}
  def rename_discord_channel(maybe_channel_id, new_name) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil ->
        {:error, "No channel found"}

      channel_id ->
        Channel.modify(channel_id, %{
          name: new_name
        })
    end
  end

  @spec get_original_interaction_response(Nostrum.Struct.Interaction.t()) ::
          Nostrum.Api.error() | {:ok, Nostrum.Struct.Message.t()}
  def get_original_interaction_response(interaction) do
    Interaction.original_response(interaction)
  end

  @spec new_interaction_response(%{
    required(:content) => String.t(),
    optional(:flags) => non_neg_integer(),
    optional(:components) => list(Nostrum.Struct.Component.t())
  }) :: map
  def new_interaction_response(%{content: _content} = data) do
    %{
      type: 4,
      data: data
    }
  end

  @spec edit_interaction_response(Nostrum.Struct.Interaction.t(), map()) ::
          {:ok, Nostrum.Struct.Message.t()} | {:error, Nostrum.Api.error()}
  def edit_interaction_response(interaction, %{} = changes) do
    Interaction.edit_response(interaction, changes)
  end

  @spec respond_to_interaction(Nostrum.Struct.Interaction.t(), %{
    optional(:type) => non_neg_integer(),
    optional(:data) => map
  }) :: {:ok} | Nostrum.Api.error() | {:error, :discord_disabled}
  def respond_to_interaction(interaction, data) do
    Interaction.create_response(interaction, data)
  end


  @spec create_interaction_followup_message(String.t(), map) ::
          {:ok, Nostrum.Struct.Message.t()} | Nostrum.Api.error()
  def create_interaction_followup_message(token, message_map) do
    Interaction.create_followup_message(token, message_map)
  end

  @spec delete_interaction_response(Nostrum.Struct.Interaction.t()) :: {:ok} | Nostrum.Api.error()
  def delete_interaction_response(interaction) do
    Interaction.delete_response(interaction)
  end

  @spec get_discord_message(non_neg_integer | String.t(), non_neg_integer) ::
          {:ok, Nostrum.Struct.Message.t()} | {:error, any()} | nil
  def get_discord_message(maybe_channel_id, message_id) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil -> {:error, "No channel found"}
      channel_id -> Message.get(channel_id, message_id)
    end
  end

  @spec edit_discord_message(non_neg_integer | String.t(), non_neg_integer, String.t()) ::
          map | nil | {:error, any()}
  def edit_discord_message(maybe_channel_id, message_id, new_message)
      when is_integer(message_id) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil ->
        {:error, "No channel found"}

      channel_id ->
        Message.edit(channel_id, message_id, content: new_message)
    end
  end

  @spec delete_discord_message(non_neg_integer | String.t(), non_neg_integer) ::
          map | nil | {:error, any()}
  def delete_discord_message(maybe_channel_id, message_id) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil -> {:error, "No channel found"}
      channel_id -> Message.delete(channel_id, message_id)
    end
  end

  @spec create_discord_reaction(non_neg_integer | String.t(), non_neg_integer, String.t()) ::
          map | nil | {:error, any()}
  def create_discord_reaction(maybe_channel_id, message_id, emoji) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil -> {:error, "No channel found"}
      channel_id -> Message.react(channel_id, message_id, URI.encode(emoji))
    end
  end

  @spec delete_discord_reaction(non_neg_integer | String.t(), non_neg_integer, String.t()) ::
          map | nil | {:error, any()}
  def delete_discord_reaction(maybe_channel_id, message_id, emoji) do
    case get_channel_id_from_any(maybe_channel_id) do
      nil -> {:error, "No channel found"}
      channel_id -> Message.unreact(channel_id, message_id, URI.encode(emoji))
    end
  end

  @spec get_channel_id_from_any(any) :: non_neg_integer() | nil
  defp get_channel_id_from_any(identifier) when is_integer(identifier) do
    if identifier < 999_999 do
      case get_discord_channel(identifier) do
        nil -> nil
        %{id: channel_id} -> channel_id
      end
    else
      identifier
    end
  end

  defp get_channel_id_from_any(%{channel_id: channel_id}), do: channel_id

  defp get_channel_id_from_any(identifier) do
    case get_discord_channel(identifier) do
      nil -> nil
      %{id: channel_id} -> channel_id
    end
  end

  @spec get_guild_id() :: integer | nil
  def get_guild_id do
    Application.get_env(:barbridge, Barbridge.Discord)[:guild_id]
  end
end
