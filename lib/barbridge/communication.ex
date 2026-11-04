defmodule Barbridge.Communication do
  @moduledoc false

  alias Barbridge.Communication.ApiLib

  defdelegate get_reports(opts \\ []), to: ApiLib

  defdelegate get_actions(opts \\ []), to: ApiLib
end
