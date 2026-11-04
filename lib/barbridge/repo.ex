defmodule Barbridge.Repo do
  use Ecto.Repo,
    otp_app: :barbridge,
    adapter: Ecto.Adapters.Postgres
end
