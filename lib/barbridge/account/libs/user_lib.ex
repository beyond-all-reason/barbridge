defmodule Barbridge.Account.UserLib do
  @moduledoc false

  alias Barbridge.Account.User
  alias Barbridge.Account.UserQueries
  alias Barbridge.Repo

  alias Ecto.UUID

  @spec create_user(pos_integer()) :: {:ok, User} | {:error, Ecto.Changeset.t()}
  def create_user(discord_user_id) do
    user_id = UUID.generate()

    %User{}
    |> User.changeset(%{id: user_id, primary_discord_user_id: discord_user_id})
    |> Repo.insert()
  end

  @spec update_primary_discord_profile(User.t(), integer()) ::
          {:ok, User} | {:error, Ecto.Changeset.t()}
  def update_primary_discord_profile(%User{} = user, profile_id) do
    user
    |> User.changeset(%{primary_discord_user_id: profile_id})
    |> Repo.update()
  end

  @spec list_users() :: [Ecto.Schema.t() | term()]
  def list_users do
    UserQueries.users()
    |> Repo.all()
  end

  @spec get_by_id(Ecto.UUID.t()) :: User.t() | nil
  def get_by_id(id) do
    UserQueries.users()
    |> UserQueries.where_id(id)
    |> Repo.one()
  end

  @spec get_by_discord_id(pos_integer()) :: User.t()
  def get_by_discord_id(discord_id) do
    UserQueries.users()
    |> UserQueries.preload_primary_discord_user()
    |> UserQueries.where_primary_discord_user_id(discord_id)
    |> Repo.one()
  end
end
