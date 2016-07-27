defmodule DGUWeb.Publisher do
  use DGUWeb.Web, :model

  schema "publishers" do
    field :name, :string
    field :title, :string
    field :url, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :url])
    |> validate_required([:name, :title, :url])
  end
end
