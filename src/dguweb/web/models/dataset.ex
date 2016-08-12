defmodule DGUWeb.Dataset do
  use DGUWeb.Web, :model

  alias DGUWeb.Repo

  schema "datasets" do
    field :name, :string
    field :title, :string
    field :description, :string
    belongs_to :publisher, DGUWeb.Publisher
    has_many :datafiles, DGUWeb.DataFile
    timestamps()
  end

  @required_fields [:name, :title, :publisher_id, :description]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :description, :publisher_id])
    |> validate_required(@required_fields)
  end

  def fields_for_search(dataset) do
      d = dataset
      |> Repo.preload(:publisher)

    fields_with_publisher( d, d.publisher )
  end

  def fields_with_publisher(dataset, nil) do
    dataset
    |> Map.take([:name, :title, :description])
    |> Enum.into([])
  end

  def fields_with_publisher(dataset, publisher) do
    dataset
    |> Map.take([:name, :title, :description])
    |> Map.put(:publisher_name, publisher.name)
    |> Map.put(:publisher_title, publisher.title)
    |> Enum.into([])
  end

end
