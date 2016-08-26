defmodule DGUWeb.DatasetController do
  use DGUWeb.Web, :controller

  alias DGUWeb.Repo
  alias DGUWeb.Dataset
  alias DGUWeb.Theme
  alias DGUWeb.Upload
  alias DGUWeb.Publisher

  def index(conn, _params) do
    render(conn, "index.html", datasets: [])
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
    upload_obj = Repo.get(Upload, String.to_integer(upload))

    case changeset.valid? do
      true ->

        ckan_dataset = changeset.changes
        |> Map.delete(:publisher_id)
        |> Map.put(:notes, changeset.changes.description)
        |> Map.delete(:description)
        |> Map.put(:resources, [Dataset.resource_from_upload(upload_obj)])
        |> Map.put(:owner_org, upload_obj.publisher)
        |> Map.put(:license_id, "uk-ogl")

        Dataset.create(conn, ckan_dataset)
        Repo.delete(upload_obj)

        conn
        |> put_flash(:info, "Dataset created successfully.")
        |> redirect(to: dataset_path(conn, :show, ckan_dataset.name))
      false ->
        render(conn, "new.html", changeset: changeset,
          themes: get_themes_for_select,
          publisher: get_publisher_from_upload(upload),
          upload: upload
        )
    end
  end

  defp get_themes_for_select() do
    Repo.all(Theme)
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
    dataset = Dataset.show(conn, id)
    conn |> show_dataset(dataset)
  end

  def show_dataset(conn, nil) do
    conn
    |> put_status(:not_found)
    |> render(DGUWeb.ErrorView, "404.html")
  end

  def show_dataset(conn, dataset) do
    render(conn, "show.html", dataset: dataset)
  end

  def edit(conn, %{"id" => id}) do
    dataset = Dataset.show(conn, id)
    changeset = Dataset.changeset(dataset)

    publisher = Publisher.show(conn, dataset.owner_org)

    render(conn, "edit.html", dataset: dataset, changeset: changeset,
        themes: get_themes_for_select,
        publisher: publisher,
        upload: nil
      )
  end

  def update(conn, %{"id" => id, "dataset" => dataset_params}) do
  end

  def delete(conn, %{"id" => id}) do
  end


end
