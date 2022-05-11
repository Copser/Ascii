defmodule Ascii.Repo do
  use Ecto.Repo,
    otp_app: :ascii,
    adapter: Ecto.Adapters.Postgres
end
