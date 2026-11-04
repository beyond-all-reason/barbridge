defmodule Barbridge.Discord.DiscordProfile do
  @moduledoc false
  use Barbridge.FileMacros, :schema

  @primary_key false
  typed_schema "discord_profiles" do
    field :id, :integer, primary_key: true
    belongs_to :user, Barbridge.Account.User, type: Ecto.UUID

    timestamps()
  end

  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(id user_id)a)
    |> validate_required(~w(id user_id)a)
    |> unique_constraint(:id)
  end
end
