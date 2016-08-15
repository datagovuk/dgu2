defmodule DGUWeb.Upload do
  use DGUWeb.Web, :model

  schema "uploads" do
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
    |> cast(params, [:url, :dataset, :publisher, :content_type, :path, :warnings, :errors, :file])
    |> validate_url_or_file
    |> process_uploaded_file
  end

  defp process_uploaded_file(changeset) do
    do_file(changeset, get_field(changeset, :file))
  end

  defp do_file(changeset, nil), do: changeset
  defp do_file(changeset, file) do
    [_name, ext] = String.split(file.filename, ".")
    name = "#{UUID.uuid4}.#{ext}"
    newpath = "/tmp/#{name}"

    File.rename(file.path, newpath)

    c = put_change(changeset, :content_type, file.content_type)
    c = put_change(c, :path, newpath)
    c = put_change(c, :url, "/downloads/#{name}")

    c
  end

  defp validate_url_or_file(changeset) do
    a = get_field(changeset, :file)
    b = get_field(changeset, :url)

    if a == nil && b == nil do
      c = add_error(changeset, :url, "Please specify a URL or a file to upload")
    end

    if a && b do
      c = add_error(changeset, :url, "Please only specify a URL or add a file, not both")
    end

    c || changeset
  end


end
