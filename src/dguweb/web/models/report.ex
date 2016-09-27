defmodule DGUWeb.Report do

  alias DGUWeb.CKAN.Client

  def broken_links(conn, publisher_shortname) do
    conn.assigns[:ckan]
    |> Client.report_data_get(id: "broken-links")
    |> Map.get(:result)
    |> hd
    |> Map.get(:table)
    |> Enum.find(fn x-> x.organization_name == publisher_shortname end)
  end


end