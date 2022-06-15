defmodule Dashoe.Repo do
  use Ecto.Repo,
    otp_app: :dashoe,
    adapter: Ecto.Adapters.Postgres
end
