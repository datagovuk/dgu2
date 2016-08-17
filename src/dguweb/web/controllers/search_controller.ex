defmodule DGUWeb.SearchController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Util.Pagination

  def index(conn, _params) do
    render conn, :index
  end

  # Search with an empty search term
  def search(conn, %{"q" => ""} = params), do: showall(conn, params)

  # Search with a valid search term
  def search(conn, %{"q" => query} = params) do
    q = URI.encode(query)
    do_search(conn, q, params)
  end

  # Search with no q param
  def search(conn, params), do: showall(conn, params)

  # Show all datasets in the index
  defp showall(conn, params), do: do_search(conn, "*", params)

  defp do_search(conn, querystring, params) do

    result = Repo.search(querystring)
    page_number = get_page_number(params)
    pagination = Pagination.create(result.hits.total)
    offset = Pagination.offset_for_page(pagination, page_number)

    result = Repo.search querystring, offset

    query = case querystring do
      "*" -> ""
      x -> x
    end

    render conn, :search, query: query, results: result.hits.hits,
      pagination: pagination, offset: offset, page_number: page_number
  end


  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end
end
