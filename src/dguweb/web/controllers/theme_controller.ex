defmodule DGUWeb.ThemeController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Theme, Dataset}

  def index(conn, _params) do
    themes = Repo.all(Theme)
    render(conn, "index.html", themes: themes)
  end

  def show(conn, %{"id" => id}) do
    theme = Repo.get_by!(Theme, name: id)
    render(conn, "show.html", theme: theme, datasets: get_datasets(theme))
  end

  defp get_datasets(theme) do
    Repo.all(from d in Dataset, where: d.theme_id == ^theme.id)
  end

end

