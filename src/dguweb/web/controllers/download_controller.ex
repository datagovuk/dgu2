defmodule DGUWeb.DownloadController do
  use DGUWeb.Web, :controller

  # Used during development.  In production we'll serve this with nginx
  def download(conn, %{"path"=>path}) do
    root = Application.get_env(:dguweb, :upload_path)
    fullpath =Path.join(root, path)

    conn
    |> put_resp_header( "Content-type", "application/octet-stream")
    |> send_file(200, fullpath)
  end

end
