defmodule DGUWeb.PublishController do
  use DGUWeb.Web, :controller
  alias DGUWeb.Upload.Info, as: UploadInfo

  def index(conn, _params) do
    conn
    |> clear_session
    |> render("index.html", current_files: [])
  end

  def add_file(conn, %{"file"=>upload}=params) do
    # We have to move this file before the request completes
    info = %UploadInfo{filename: upload.filename}

    render_add_file(conn, info)
  end

  def add_file(conn, %{"url"=>url}=params) do
    info = %UploadInfo{filename: url}    
    
    render_add_file(conn,  info)
  end

  defp render_add_file(conn, info) do
    current = [info | get_session(conn, :current_files) || []]

    conn
    |> put_session(:current_files, current)
    |> render("index.html", current_files: current)
end 

  def find(conn, _params) do 
    current = get_session(conn, :current_files) || []

    render(conn, "find.html", current_files: current)
  end 

end
