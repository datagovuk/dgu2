defmodule DGUWeb.ThemeController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Theme, Dataset}
  alias DGUWeb.Util.Pagination

  def index(conn, _params) do
    themes = Repo.all(Theme)
    render(conn, "index.html", themes: themes)
  end

  def show(conn, %{"id" => theme_name}=params) do
    theme = Repo.get_by(Theme, name: theme_name)
    page_number = get_page_number(params)
    show_datasets(conn, theme, page_number)
  end

  def show_datasets(conn, nil, _page_number) do
   conn
   |> put_status(:not_found)
   |> render(DGUWeb.ErrorView, "404.html")
  end

  def show_datasets(conn, theme, page_number) do
    page_number = if page_number < 1, do: 1, else: page_number
    offset = case page_number do
      1 ->
        0
      other ->
        (other * 10) - 10
    end

    response = Dataset.search(conn, "", [fq: "theme-primary:#{theme.title}", rows: 10, start: offset])
    pagination = Pagination.create(response.count)

    render(conn, "show.html", datasets: response.results, theme: theme,
      pagination: pagination, page_number: page_number, offset: offset)
  end


  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end
end

