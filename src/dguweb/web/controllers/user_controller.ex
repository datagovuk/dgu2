defmodule DGUWeb.UserController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    user = conn.assigns[:current_user]
    do_index(conn, user)
  end

  defp do_index(conn, nil), do: redirect(conn, to: "/")
  defp do_index(conn, _user) do
    publishers = conn.assigns[:user_publishers] || []
    render(conn, "index.html", publishers: publishers, tasks: fake_tasks)
  end

  defp fake_tasks do
    [
      "<a href=''>Organogram</a> update was due 3 days ago - <a href=''>Add data</a>",
      "<a href=''>Spend Data</a> has a broken link - <a href=''>Fix it now</a>",
      "<a href=''>Spend Data</a> is due to be updated in 5 days -  <a href=''>Add data</a>",
    ]
  end

end