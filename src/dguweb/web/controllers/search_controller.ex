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
    page_number = if page_number < 1, do: 1, else: page_number

    offset = case page_number do
      1 ->
        0
      other ->
        (other * 10) - 10
    end

    fq_dict = params_to_fq(params)
    fq = fq_dict |> Enum.map(fn {k, v} -> "#{k}:#{URI.encode(v)}" end) |> Enum.join(" ")

    response = Dataset.search(conn, URI.encode(querystring), [rows: 10, start: offset, fq: fq])
    pagination = Pagination.create(response.count)

    datasets = response.results
    |> Enum.map(fn dataset->
      %{
         name: dataset.name,
         title: dataset.title,
         description: dataset.notes,
         publisher_name: dataset.organization.name,
         publisher_title: dataset.organization.title,
         resource_formats: dataset.resources |> Enum.map(fn x-> x.format end) |> Enum.uniq(),
       }
    end)

    querystring = if querystring == "*:*", do: "", else: querystring

    render conn, :search, query: querystring, results: datasets,
      pagination: pagination, offset: offset, page_number: page_number,
      fq_dict: fq_dict
  end

  defp params_to_fq(params) do
    fqlist = ["theme-primary", "res_format"]
    Map.take(params, fqlist)
  end
  defp params_to_fq(nil), do: nil


  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end
end
