defmodule DGUWeb.PageController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
