defmodule DGUWeb.PageController do
  use DGUWeb.Web, :controller
  alias DGUWeb.Theme 
  
  def index(conn, _params) do
    themes = Repo.all(Theme)
    render conn, "index.html", themes: themes 
  end


end
