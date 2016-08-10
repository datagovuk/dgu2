defmodule DGUWeb.Dataset do
  use DGUWeb.Web, :model

  schema "datasets" do
    field :name, :string
    field :title, :string
    belongs_to :publisher, DGUWeb.Publisher
    has_many :datafiles, DGUWeb.DataFile
    timestamps()
  end

  @required_fields [:name, :title, :publisher_id]

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :publisher_id])
    |> validate_required(@required_fields)
  end
end
