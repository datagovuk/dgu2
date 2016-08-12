defmodule DGUWeb.SearchController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def search(conn, params) do
    query = params |> Map.get("q")

    q = query |> String.replace(" ","+")
    result = Repo.search(q)

    render conn, "search.html", query: query, results: result.hits.hits, total: result.hits.total
  end

end
