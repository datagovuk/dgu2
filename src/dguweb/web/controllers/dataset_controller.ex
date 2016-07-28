defmodule DGUWeb.DatasetController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Dataset

  def index(conn, _params) do
    datasets = Repo.all(Dataset)
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
    dataset = Repo.get!(Dataset, id)
    render(conn, "show.html", dataset: dataset)
  end

  def edit(conn, %{"id" => id}) do
    dataset = Repo.get!(Dataset, id)
    changeset = Dataset.changeset(dataset)
    render(conn, "edit.html", dataset: dataset, changeset: changeset)
  end

  def update(conn, %{"id" => id, "dataset" => dataset_params}) do
    dataset = Repo.get!(Dataset, id)
    changeset = Dataset.changeset(dataset, dataset_params)

    case Repo.update(changeset) do
      {:ok, dataset} ->
        conn
        |> put_flash(:info, "Dataset updated successfully.")
        |> redirect(to: dataset_path(conn, :show, dataset))
      {:error, changeset} ->
        render(conn, "edit.html", dataset: dataset, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    dataset = Repo.get!(Dataset, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(dataset)

    conn
    |> put_flash(:info, "Dataset deleted successfully.")
    |> redirect(to: dataset_path(conn, :index))
  end
end