defmodule DGUWeb.Dataset do
  use DGUWeb.Web, :model

  alias CKAN.Client
  alias DGUWeb.Repo

  schema "datasets" do
    field :name, :string
    field :title, :string
    field :description, :string
    field :type, :string

    belongs_to :theme, DGUWeb.Theme
    belongs_to :publisher, DGUWeb.Publisher
    has_many :datafiles, DGUWeb.DataFile
    timestamps()
  end

 def create(conn, dataset) do
    call = conn.assigns[:ckan]
    |> Client.package_create(dataset)
    call.result
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


  @required_fields [:name, :title, :publisher_id, :description]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :description, :type, :publisher_id, :theme_id])
    |> validate_required(@required_fields)
  end

  def fields_for_search(dataset) do
      d = dataset
      |> Repo.preload(:publisher)
      |> Repo.preload(:theme)

    fields = fields_with_publisher( d, d.publisher )
    if d.theme do
      fields = Keyword.put(fields, :theme, d.theme.name)
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
