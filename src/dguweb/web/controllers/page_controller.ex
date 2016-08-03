defmodule DGUWeb.PageController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def search(conn, params) do
    query = params |> Map.get("q")
    render conn, "search.html", query: query
  end

end
