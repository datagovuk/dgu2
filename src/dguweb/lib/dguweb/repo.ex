defmodule DGUWeb.Repo do
  use Ecto.Repo, otp_app: :dguweb
  use Scrivener, page_size: 10
end
