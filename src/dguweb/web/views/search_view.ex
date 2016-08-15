defmodule DGUWeb.SearchView do
  use DGUWeb.Web, :view

  def render("search.json", %{results: datasets}) do
    datasets
    |> Enum.map( fn x-> x._source end)
  end


end
