defmodule DGUWeb.Publisher do
  use DGUWeb.Web, :model

  schema "publishers" do
    field :name, :string
    field :title, :string
    field :url, :string
    field :description, :string    
    has_many :datasets, DGUWeb.Dataset

    field :abbreviation, :string 
    field :category, :string 
    field :closed, :boolean 

    field :foi_name, :string
    field :foi_email, :string
    field :foi_web, :string
    field :foi_phone, :string

    field :contact_name, :string
    field :contact_email, :string
    field :contact_phone, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:name, :title, :url, :description, :abbreviation, :category, :closed])
    |> validate_required([:name, :title, :url])
  end
end
