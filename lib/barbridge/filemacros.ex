defmodule Barbridge.FileMacros do
  @moduledoc false

  def schema do
    quote do
      use TypedEctoSchema
      import Ecto.Changeset
    end
  end

  def queries do
    quote do
      import Ecto.Query, warn: false
      import Barbridge.Helper.QueryHelpers
      alias Ecto.Multi
      alias Barbridge.Repo
    end
  end

  def library_newform do
    quote do
      alias Barbridge.Helper.QueryHelpers
      alias Barbridge.Repo
    end
  end

  defmacro __using__(which) when is_atom(which) do
    apply(__MODULE__, which, [])
  end
end
