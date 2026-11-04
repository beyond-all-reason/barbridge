defmodule Barbridge.Discord.DiscordChannel do
  @moduledoc false

  use Barbridge.FileMacros, :schema

  @allowed_functions [:post_chat_reports, :post_action_reports, :post_actions]

  @primary_key false
  typed_schema "discord_channels" do
    field :id, :integer, primary_key: true

    field :function, Ecto.Enum,
      values: [post_chat_reports: 0, post_action_reports: 1, post_action: 2]

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  @spec changeset(map(), map()) :: Ecto.Changeset.t()
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, ~w(id function)a)
    |> validate_required(~w(id function)a)
    |> validate_inclusion(:function, @allowed_functions)
    |> unique_constraint(:id)
  end
end
