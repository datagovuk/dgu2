defmodule DGUWeb.UploadController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Repo, Upload, Dataset, Publisher, DataFile}

  # Start of the new upload process.  Expecting user to add a file or url and
  # then post to create
  def new(conn, params) do
    changeset = Upload.changeset(%Upload{})

    dataset = Repo.get_by(Dataset, name: Map.get(params, "dataset") || "")
    publisher = Repo.get_by(Publisher, name: Map.get(params, "publisher") || "")

    render(conn, "new.html", changeset: changeset,
      publisher: publisher, dataset: dataset)
  end

  # User has provided a URL or a file.  We'll validate it and try and create
  # an upload object before redirecting to the correct place.
  def create(conn, %{"upload" => upload_params}) do
    changeset = Upload.changeset(%Upload{}, upload_params)

    case Repo.insert(changeset) do
      {:ok, upload} ->
        conn
        |> put_flash(:info, "Upload created successfully.")
        |> get_redirect(upload)
      {:error, changeset} ->
        dataset = Repo.get_by(Dataset, name: Map.get(upload_params, "dataset") || "")
        publisher = Repo.get_by(Publisher, name: Map.get(upload_params, "publisher") || "")

        render(conn, "new.html", changeset: changeset, dataset: dataset, publisher: publisher)
    end
  end

  def get_redirect(conn, %Upload{dataset: dataset_name}=params) do
    dataset = Repo.get_by(Dataset, name: dataset_name)

    # Create a new data_file for the dataset
    changeset = DataFile.changeset_from_upload(params, dataset.id)
    case Repo.insert(changeset) do
      {:ok, _datafile} ->
        # Delete the upload once we are happy the data_file is added
        conn
        |> put_flash(:info, "Datafile created successfully.")
        |> redirect(to: dataset_path(conn, :show, dataset.name))
      {:error, changeset} ->
        dataset = Repo.get_by(Dataset, name: Map.get(params, "dataset") || "")
        publisher = Repo.get_by(Publisher, name: Map.get(params, "publisher") || "")
        render(conn, "new.html", changeset: changeset, dataset: dataset, publisher: publisher)
    end


  end

  def get_redirect(conn, %{publisher: _publisher_name}=params) do
    redirect(conn, to: upload_path(conn, :show, params.id) )
  end

  def show(conn, %{"id" => id}) do
    upload = Repo.get!(Upload, id)
    render(conn, "show.html", upload: upload)
  end

end
