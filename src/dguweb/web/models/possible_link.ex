defmodule DGUWeb.PossibleLink do
  use DGUWeb.Web, :model

  alias DGUWeb.Repo

  schema "possible_links" do
    field :url, :string
    field :publisher_name, :string
    field :processed, :boolean, default: false

    timestamps()
  end

  def get_for_publisher(name) do
    Repo.all(
      from p in __MODULE__,
         select: p,
         where: p.publisher_name == ^name
    )

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
