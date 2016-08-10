defmodule DGUWeb.ThemeController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Theme

  def index(conn, _params) do
    themes = Repo.all(Theme)
    render(conn, "index.html", themes: themes)
  end

  def show(conn, %{"id" => id}) do
    theme = Repo.get_by!(Theme, name: id)
    render(conn, "show.html", theme: theme)
  end

end
