defmodule DGUWeb.PageController do
  use DGUWeb.Web, :controller
  alias DGUWeb.Theme 
  
  def index(conn, _params) do
    themes = Repo.all(Theme)
    render conn, "index.html", themes: themes 
  end

  def search(conn, params) do
    query = params |> Map.get("q")
    render conn, "search.html", query: query
  end

end
