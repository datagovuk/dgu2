defmodule DGUWeb.DatasetController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Dataset

  def index(conn, _params) do
    datasets = Repo.all(Dataset) |> Repo.preload(:publisher)
    render(conn, "index.html", datasets: datasets)
  end

  def new(conn, _params) do
    changeset = Dataset.changeset(%Dataset{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"dataset" => dataset_params}) do
    changeset = Dataset.changeset(%Dataset{}, dataset_params)

    case Repo.insert(changeset) do
      {:ok, _dataset} ->
        conn
        |> put_flash(:info, "Dataset created successfully.")
        |> redirect(to: dataset_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    dataset = Repo.get_by!(Dataset, name: id) 
    |> Repo.preload(:publisher)
    |> Repo.preload(:datafiles)

    render(conn, "show.html", dataset: dataset)
  end

  def edit(conn, %{"id" => id}) do
    dataset = Repo.get_by!(Dataset, [name: id])
    changeset = Dataset.changeset(dataset)
    render(conn, "edit.html", dataset: dataset, changeset: changeset)
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
        render(conn, "edit.html", dataset: dataset, changeset: changeset)
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
