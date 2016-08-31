defmodule DGUWeb.Dataset do
  use DGUWeb.Web, :model

  alias DGUWeb.CKAN.Client
  alias DGUWeb.Repo

  schema "datasets" do
    field :name, :string
    field :title, :string
    field :description, :string
    field :type, :string
    field :owner_org, :string, virtual: true

    belongs_to :theme, DGUWeb.Theme
    timestamps()
  end

  def create(conn, dataset) do
    call = conn.assigns[:ckan]
    |> Client.package_create(dataset)
    call.result
  end

  def add_resource(conn, dataset_name, upload_obj) do
    dataset = show(conn, dataset_name)

    r = resource_from_upload(upload_obj)
    |> Map.put(:owner_org, upload_obj.publisher)
    |> Map.put(:package_id, dataset_name)

    call = conn.assigns[:ckan]
    |> Client.resource_create(r)

    key = "package_show:#{dataset_name}"
    Cachex.del(:request_cache, key)

    key = "package_show:#{dataset_name}"
    Cachex.del(:request_cache, key)

    call
  end

  def resource_from_upload(upload) do
    %{
      id: UUID.uuid4(),
      name: upload.name,
      description: upload.description,
      url: upload.url,
      format: upload.content_type,
    }
  end

  def search(conn, q, params \\ []) do
    call = conn.assigns[:ckan]
    |> Client.package_search(Keyword.merge([q: q], params))
    call.result
  end

  def show(conn, id) do
    key = "package_show:#{id}"
    case Cachex.get!(:request_cache, key) do
      nil ->
        call = Client.package_show(conn.assigns[:ckan], [id: id])
        dataset_or_nil(key, call)
      results ->
        results
    end
  end

  def dataset_or_nil(_key, %{error: _error}) do
   nil
  end

  def dataset_or_nil(key, response) do
    Cachex.set(:request_cache, key, response.result, DGUWeb.cache_opts)
    response.result
  end


  @required_fields [:name, :title, :description]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :description, :type, :owner_org, :theme_id])
    |> validate_required(@required_fields)
  end

  def fields_for_search(dataset) do
      d = dataset
      |> Repo.preload(:publisher)
      |> Repo.preload(:theme)

    fields = fields_with_publisher( d, d.publisher )
    fields = if d.theme do
      Keyword.put(fields, :theme, d.theme.name)
    end
    fields
  end

  def fields_with_publisher(dataset, nil) do
    dataset
    |> Map.take([:name, :title, :description, :type])
    |> Enum.into([])
  end

  def fields_with_publisher(dataset, publisher) do
    dataset
    |> Map.take([:name, :title, :description, :type])
    |> Map.put(:publisher_name, publisher.name)
    |> Map.put(:publisher_title, publisher.title)
    |> Enum.into([])
  end

end
