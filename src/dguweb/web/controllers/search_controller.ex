defmodule DGUWeb.SearchController do
  use DGUWeb.Web, :controller

  def index(conn, _params) do
    render conn, :index
  end


  def search(conn, %{}), do: showall(conn)
  def search(conn, %{"q" => ""}), do: showall(conn)

  def search(conn, %{"q" => query}) do
    result = URI.encode(query) |> Repo.search
    render conn, :search, query: query, results: result.hits.hits, total: result.hits.total
  end


  defp showall(conn) do
    result = Repo.search "*"
    render conn, :search, query: "", results: result.hits.hits, total: result.hits.total
  end


end
