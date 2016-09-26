defmodule DGUWeb.PossibleLink do
  use DGUWeb.Web, :model

  schema "possible_links" do
    field :url, :string
    field :publisher_name, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:url, :publisher_name])
    |> validate_required([:url, :publisher_name])
  end
end
