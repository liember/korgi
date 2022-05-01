defmodule Korgi.Repo do
  use Ecto.Repo,
    otp_app: :korgi,
    adapter: Ecto.Adapters.Postgres
end
