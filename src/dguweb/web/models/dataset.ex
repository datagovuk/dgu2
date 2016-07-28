defmodule DGUWeb.Dataset do
  use DGUWeb.Web, :model

  schema "datasets" do
    field :name, :string
    field :title, :string
    belongs_to :publisher, DGUWeb.Publisher

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title])
    |> validate_required([:name, :title])
  end
end
