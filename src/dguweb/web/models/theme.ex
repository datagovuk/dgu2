defmodule DGUWeb.Theme do
  use DGUWeb.Web, :model

  schema "themes" do
    field :name, :string
    field :title, :string
    field :description, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :description])
    |> validate_required([:name, :title, :description])
  end
end
