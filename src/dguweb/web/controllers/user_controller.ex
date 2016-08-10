defmodule DGUWeb.UserController do
  use DGUWeb.Web, :controller
  
  alias DGUWeb.User

  def index(conn, _params) do
    user = conn |> DGUWeb.Session.current_user     
    do_index(conn, user)
  end 

  defp do_index(conn, nil), do: redirect(conn, to: "/")
  defp do_index(conn, user) do 
    userpubs = DGUWeb.User.publishers(user)
    render(conn, "index.html", publishers: userpubs)
  end

end