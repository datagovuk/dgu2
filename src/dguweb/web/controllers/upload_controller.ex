defmodule DGUWeb.UploadController do
  use DGUWeb.Web, :controller

  alias DGUWeb.{Repo, Upload, Dataset, Publisher}
  alias DGUWeb.Util.Pagination

  # Start of the new upload process.  Expecting user to add a file or url and
  # then post to create
  def new(conn, params) do
    changeset = Upload.changeset(%Upload{})

    dataset = Dataset.show(conn, Map.get(params, "dataset"))
    publisher = Publisher.show(conn, Map.get(params, "publisher"))

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


  # If we are uploading data and we already know the dataset, then we will add the data file
  # and then redirect to the dataset itself.
  def get_redirect(conn, %Upload{dataset: dataset_name}=params) when not is_nil(dataset_name) do
      Dataset.add_resource(conn, dataset_name, params)
      conn |> redirect(to: dataset_path(conn, :show, dataset_name))
  end

  # If we have a publisher, but no dataset then redirect to the chooser
  def get_redirect(conn, %{publisher: _publisher_name}=params) do
    redirect(conn, to: upload_path(conn, :show, params.id) )
  end

  # Allows the user to choose where they intend to put the data that they
  # just uploaded. This data will be posted to :put
  def show(conn, %{"id" => id}) do
    upload = Repo.get!(Upload, id)
    publisher = %{}
    datasets = []

    render(conn, "show.html", upload: upload, publisher: publisher, datasets: datasets)
  end


  defp add_to_dataset(conn, dataset_name, upload_id) do
    upload = Repo.get_by(Upload, id: upload_id)

    Dataset.add_resource(conn, dataset_name, upload)
    conn |> redirect(to: dataset_path(conn, :show, dataset_name))
   end

   # This can be an existing dataset, in which case we'll
   # redirect them to :find, it can be a new dataset, in which case they'll
   # go to /dataset/new or it can be a typed dataset in which case we'll
   # just get the redirect and send them there.
   def put(conn, %{"add_to"=> "dataset:" <> dataset_name, "id"=>upload_id}) do
     add_to_dataset(conn, dataset_name, upload_id)
   end

   # Just redirect to dataset new but tell it what the upload id is
   def put(conn, %{"add_to"=> "new", "id"=>upload_id}) do
     conn
     |> redirect(to: dataset_path(conn, :new, upload: upload_id))
   end

   # Redirect to :find
   def put(conn, %{"add_to"=> "existing", "id"=>upload_id}) do
     conn
     |> redirect(to: upload_path(conn, :find, upload_id))
   end

   # Allow the user
   def find(conn, %{"id" => upload_id}=params) do

     upload = Repo.get_by(Upload, id: upload_id)
     publisher = Publisher.show(conn, upload.publisher)

     page_number = get_page_number(params)
     page_number = if page_number < 1, do: 1, else: page_number
     offset = case page_number do
      1 ->
         0
      other ->
        ((other * 10) - 10)
    end

    response = Dataset.search(conn, "", [fq: "organization:#{publisher.name}", rows: 10, start: offset])
    pagination = Pagination.create(response.count)

     conn
     |> render("find.html", upload: upload, publisher: publisher, datasets: response.results,
      pagination: pagination, page_number: page_number, offset: offset)
   end

  defp get_page_number(params) do
    params |> Map.get("page", "1") |> String.to_integer
  end


end
