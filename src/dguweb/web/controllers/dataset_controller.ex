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
      publisher: get_publisher_from_upload(conn, upload),
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
          publisher: get_publisher_from_upload(conn, upload),
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

  defp get_publisher_from_upload(conn, upload) do
    up = Repo.get(Upload, upload)
    Publisher.show(conn, up.publisher)
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
    is_organogram = dataset.title
      |> String.downcase
      |> String.contains?("organogram")

    render_dataset(conn, dataset, is_organogram)
  end

  def render_dataset(conn, dataset, true) do

    find_type = Map.get(conn.query_params, "organogram", "junior")

    url_map = dataset.resources
    |> Enum.find(fn x->
      x.description |> String.downcase |> String.contains?(find_type)
    end)

    {header,rows} = case url_map do
      nil ->
        {nil, nil}
      _ ->
        url = Map.get(url_map, :url)
        response = HTTPotion.get url, [timeout: 20_000]

        filename = "/tmp/#{UUID.uuid4}.csv"
        File.write(filename, response.body)

        out_filename = "/tmp/#{UUID.uuid4}.csv"
        output = :os.cmd(to_char_list "iconv -f ISO-8859-1 -t UTF-8 #{filename} > #{out_filename}")
        File.rm(filename)

        # Convert the string into a stream for CSV decoding
        r = out_filename
        |> File.stream!
        |> CSV.decode
        |> Enum.into([])

        File.rm(out_filename)

        {hd(r), tl(r)}
    end


    render(conn, "show.html", dataset: dataset,
      organogram_header: header,
      organogram_data: rows,
      organogram_type: String.capitalize(find_type))
  end

  def render_dataset(conn, dataset, _) do
    render(conn, "show.html", dataset: dataset, organogram_data: nil, organogram_type: nil)
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


  def update(_conn, %{"id" => _id, "dataset" => _dataset_params}) do
  end

  def delete(_conn, %{"id" => _id}) do
  end


end
