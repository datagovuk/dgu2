defmodule DGUWeb.UserController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    do_index(conn, user)
  end

  defp do_index(conn, nil), do: redirect(conn, to: "/")
  defp do_index(conn, user) do
    publishers = conn.assigns[:user_publishers] || []
    render(conn, "index.html", publishers: publishers)
  end

end