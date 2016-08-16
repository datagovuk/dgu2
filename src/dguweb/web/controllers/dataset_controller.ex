defmodule DGUWeb.DatasetController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Repo
  alias DGUWeb.Dataset
  alias DGUWeb.Theme
  alias DGUWeb.Upload
  alias DGUWeb.Publisher
  alias DGUWeb.DataFile

  def index(conn, _params) do
    datasets = Repo.all(Dataset) |> Repo.preload(:publisher)
    render(conn, "index.html", datasets: datasets)
  end

  def new(conn, %{"upload"=> upload}=_params) do
    changeset = Dataset.changeset(%Dataset{})

    render(conn, "new.html", changeset: changeset,
      themes: get_themes_for_select,
      publisher: get_publisher_from_upload(upload),
      upload: upload)
  end

  def create(conn, %{"dataset" => dataset_params, "upload"=> upload}) do
    changeset = Dataset.changeset(%Dataset{}, dataset_params)

    case Repo.insert(changeset) do
      {:ok, dataset} ->

        # Upload the upload and delete
        # TODO(rdj): Make this a bit more resilient
        upload_obj = Repo.get(Upload, String.to_integer(upload))
        cs = DataFile.changeset_from_upload(upload_obj, dataset.id)

        Repo.insert(cs)
        Repo.delete(upload_obj)

        conn
        |> put_flash(:info, "Dataset created successfully.")
        |> redirect(to: dataset_path(conn, :show, dataset.name))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset,
          themes: get_themes_for_select,
          publisher: get_publisher_from_upload(upload),
          upload: upload
        )
    end
  end

  defp get_themes_for_select() do
    themes = Repo.all(Theme)
    |> Enum.map(fn t->
      {t.title, t.id}
    end)
    |> Enum.into([])
  end

  defp get_publisher_from_upload(upload) do
    up = Repo.get(Upload, upload)
    Repo.get_by(Publisher, name: up.publisher)
  end



  def show(conn, %{"id" => id}) do
    dataset = Repo.get_by!(Dataset, name: id)
    |> Repo.preload(:publisher)
    |> Repo.preload(:datafiles)
    |> Repo.preload(:theme)

    render(conn, "show.html", dataset: dataset)
  end

  def edit(conn, %{"id" => id}) do
    dataset = Repo.get_by!(Dataset, [name: id])
    changeset = Dataset.changeset(dataset)

    publisher = Repo.get(Publisher, dataset.publisher_id)

    render(conn, "edit.html", dataset: dataset, changeset: changeset,
        themes: get_themes_for_select,
        publisher: publisher,
        upload: nil
      )
  end

  def update(conn, %{"id" => id, "dataset" => dataset_params}) do
    dataset = Repo.get_by!(Dataset, name: id)
    changeset = Dataset.changeset(dataset, dataset_params)

    case Repo.update(changeset) do
      {:ok, dataset} ->
        conn
        |> put_flash(:info, "Dataset updated successfully.")
        |> redirect(to: dataset_path(conn, :show, dataset.name))
      {:error, changeset} ->
        publisher = Repo.get_by(Publisher, id: dataset.publisher_id)

        render(conn, "edit.html", dataset: dataset, changeset: changeset,
          themes: get_themes_for_select,
          publisher: publisher,
          upload: nil
        )
    end
  end

  def delete(conn, %{"id" => id}) do
    dataset = Repo.get_by!(Dataset, name: id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(dataset)

    conn
    |> put_flash(:info, "Dataset deleted successfully.")
    |> redirect(to: dataset_path(conn, :index))
  end

  ### Temporary actions for generated test csvs ###############################

  def fakecsv(conn, _params) do
   conn
    |> put_resp_content_type("text/csv")
    |> put_resp_header("Content-Disposition",
                       "attachment; filename=\"fake.csv\"")
    |> send_resp(200, csv_content)
  end

  defp csv_content do
    [['header1', 'header2'],['row1', 'data'],['row2', 'data']]
    |> CSV.encode
    |> Enum.to_list
    |> to_string
  end

end
