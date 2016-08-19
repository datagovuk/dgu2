defmodule DGUWeb.SearchController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Dataset
  alias DGUWeb.Util.Pagination

  def index(conn, _params) do
    render conn, :index
  end

  # Search with an empty search term
  def search(conn, %{"q" => ""} = params), do: showall(conn, params)

  # Search with a valid search term
  def search(conn, %{"q" => query} = params) do
    do_search(conn, query, params)
  end

  # Search with no q param
  def search(conn, params), do: showall(conn, params)

  # Show all datasets in the index
  defp showall(conn, params), do: do_search(conn, "*:*", params)

  defp do_search(conn, querystring, params) do

    page_number = get_page_number(params)
    if page_number < 1, do: page_number = 1
    case page_number do
      1 ->
        offset = 0
      other ->
        offset = (other * 10) - 10
    end

    response = Dataset.search(conn, URI.encode(querystring), [rows: 10, start: offset])
    pagination = Pagination.create(response.count)

    datasets = response.results
    |> Enum.map(fn dataset->
      %{
         name: dataset.name,
         title: dataset.title,
         description: dataset.notes,
         publisher_name: dataset.organization.name,
         publisher_title: dataset.organization.title
       }
    end)


    render conn, :search, query: querystring, results: datasets,
      pagination: pagination, offset: offset, page_number: page_number
  end


  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end
end
