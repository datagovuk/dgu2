defmodule DGUWeb.Upload do
  use DGUWeb.Web, :model

  schema "uploads" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :dataset, :string
    field :publisher, :string
    field :content_type, :string
    field :path, :string
    field :warnings, {:array, :string}
    field :errors, {:array, :string}

    field :file, :any, virtual: true
    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :url, :dataset, :publisher, :content_type, :path, :warnings, :errors, :file])
    |> validate_mimetype
    |> validate_url_or_file
    |> validate_required([:name, :description])
    |> process_uploaded_file
  end

  def validate_mimetype(changeset) do
    validate_url_mimetype(changeset, get_field(changeset, :url))
  end

  def validate_url_mimetype(changeset, nil), do: changeset
  def validate_url_mimetype(changeset, url) do
    case Mix.env do
      :test -> changeset
      _ ->
        resp = HTTPotion.head(url)
        headers = resp.headers |> Enum.into(%{})

        format = case MIME.extensions(Map.get(headers, :"Content-Type")) do
          [] -> "application/octet-stream"  # TODO(rdj) use extension in URL
          other ->
            hd(other) |> String.upcase
        end

        changeset
        |> put_change(:content_type, format)
    end
  end

  defp process_uploaded_file(changeset) do
    do_file(changeset, get_field(changeset, :file))
  end

  defp do_file(changeset, nil), do: changeset
  defp do_file(changeset, file) do
    [_name, ext] = String.split(file.filename, ".")
    name = "#{UUID.uuid4}.#{ext}"

    newpath = Application.get_env(:dguweb, :upload_path)
    |> Path.join("#{name}")

    # File.rename does not work across devices.
    System.cmd("mv", [file.path, newpath])

    host = Application.get_env(:dguweb, :host)

    changeset
    |> put_change(:content_type, file.content_type)
    |> put_change(:path, newpath)
    |> put_change(:url, "#{host}/download/#{name}")
  end

  defp validate_url_or_file(changeset) do
    a = get_field(changeset, :file)
    b = get_field(changeset, :url)
    valdation_url_or_file(changeset, a, b)
  end

  defp valdation_url_or_file(changeset, nil, nil), do: add_error(changeset, :url, "Please specify a URL or a file to upload")
  defp valdation_url_or_file(changeset, url, file) when not is_nil(url) and not is_nil(file), do: add_error(changeset, :url, "Please only specify a URL or add a file, not both")
  defp valdation_url_or_file(changeset, _url, _file), do: changeset


end
