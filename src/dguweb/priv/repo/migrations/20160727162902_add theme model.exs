defmodule :"Elixir.DGUWeb.Repo.Migrations.Add theme model" do
  use Ecto.Migration

  def change do
    create table(:themes) do
      add :name, :string
      add :title, :string
      add :description, :string

      timestamps()
    end

  end
end
