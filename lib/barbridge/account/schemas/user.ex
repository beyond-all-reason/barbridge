defmodule Barbridge.Account.User do
  @moduledoc false
  use Barbridge.FileMacros, :schema

  @primary_key false
  typed_schema "users" do
    field :id, Ecto.UUID, primary_key: true
    field :name, :string
    belongs_to :primary_discord_profile, Barbridge.Discord.DiscordProfile

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(id primary_discord_profile_id)a)
    |> validate_required(~w(id primary_discord_profile_id)a)
    |> unique_constraint([:id, :name, :primary_discord_profile_id])
  end
end
