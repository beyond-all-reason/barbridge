defmodule BarbridgeWeb.PageController do
  use BarbridgeWeb, :controller

  def home(conn, _params) do
    render(conn, :home)
  end
end
