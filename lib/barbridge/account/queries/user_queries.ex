defmodule Barbridge.Account.UserQueries do
  @moduledoc false

  alias Barbridge.Account.User

  use Barbridge.FileMacros, :queries

  @type t :: Query.t()

  @spec users() :: t()
  def users do
    from(users in User, as: :users)
  end

  @spec where_id(t(), Ecto.UUID.t()) :: t()
  def where_id(query, id) do
    from users in query,
         where: users.id == ^id
  end

  @spec where_primary_discord_user_id(t(), pos_integer()) :: t()
  def where_primary_discord_user_id(query, id) do
    from users in query,
         where: users.primary_discord_user_id == ^id
  end

  @spec order_by_id(t(), :asc | :desc) :: t()
  def order_by_id(query, direction \\ :asc) do
    if direction == :asc do
      from(users in query, order_by: [asc: users.id])
    else
      from(users in query, order_by: [desc: users.id])
    end
  end

  @spec order_by_primary_discord_user(t(), :asc | :desc) :: t()
  def order_by_primary_discord_user(query, direction \\ :asc) do
    if direction == :asc do
      from(users in query, order_by: [asc: users.primary_discord_user_id])
    else
      from(users in query, order_by: [desc: users.primary_discord_user_id])
    end
  end

  @spec preload_primary_discord_user(t()) :: t()
  def preload_primary_discord_user(query) do
    from users in query,
         left_join: primary_discord_user in assoc(users, :primary_discord_user),
         preload: [primary_discord_user: primary_discord_user]
  end
end
