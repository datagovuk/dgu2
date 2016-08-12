defmodule DGUWeb.SearchController do
  use DGUWeb.Web, :controller

  alias Tirexs.HTTP, as: Search

  def index(conn, _params) do
    render conn, :index
  end

  def search(conn, %{"q" => query}) do
    q = query |> String.replace(" ","+")
    result = Repo.search(q)
    render conn, :search, query: query, results: result.hits.hits, total: result.hits.total
  end

  def search(conn, %{}), do: render conn, :search, query: "", results: [], total: 0

end
