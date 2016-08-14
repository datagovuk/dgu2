defmodule DGUWeb.PublishController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Upload.Info, as: UploadInfo
  alias DGUWeb.Upload.Tasks

  def index(conn, _params) do
    conn
    |> render("index.html", current_files: [], error: :nil)
  end

  ### Add File, upload or URL ################################################
  #
  # When (if) we decide that this is better tracked in the database, we can
  # rely on the changeset to handle the difference validation requirements
  # and/or we can change the process flow.
  #
  ############################################################################

  def add_file(conn, params) do
    file = Map.get(params, "file", :nil)
    url = Map.get(params, "url", :nil)

    add_file_internal(conn, {file, url})
  end

  defp add_file_internal(conn, {:nil, :nil}), do: failed_add_file(conn, "Please supply a URL or a file upload.")
  defp add_file_internal(conn, {upload, ""}) do
    info = UploadInfo.from_upload(upload)
    spawn(fn-> Tasks.run_tasks(info, Tasks.file_tasks) end )
    progress_add_file(conn, info)
  end

  defp add_file_internal(conn, {:nil, "http" <> url}) do
    info = UploadInfo.from_url("http" <> url)
    |>  Tasks.run_tasks(Tasks.url_tasks)

    case info.errors do
      [] -> progress_add_file(conn, info)
      [x] -> failed_add_file(conn, x)
    end

  end

  defp add_file_internal(conn, {:nil, _url}), do: failed_add_file(conn, "URL does not appear to be valid")
  defp add_file_internal(conn, {_, _}), do: failed_add_file(conn, "Please supply a URL or a file upload, not both")

  defp failed_add_file(conn, error) do
    conn
    |> render("index.html", current_files: [], error: error)
  end

  defp progress_add_file(conn, info) do
    current = [info | get_session(conn, :current_files) || []]

    conn
    |> put_session(:current_files, current)
    |> redirect(to: publish_path(conn, :find, []))
  end

  ### Determine what the user wants to do with the uploaded data #############

  def find(conn, _params) do
    current = get_session(conn, :current_files) || []

    render(conn, "find.html", current_files: current)
  end


end
