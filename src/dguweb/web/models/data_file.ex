defmodule DGUWeb.DataFile do
  use DGUWeb.Web, :model

  schema "datafiles" do
    field :name, :string
    field :description, :string
    field :url, :string
    field :format, :string
    belongs_to :dataset, DGUWeb.Dataset

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :description, :url, :format, :dataset_id])
    |> validate_required([:name, :description, :url, :format])
  end
end
