defmodule DGUWeb.Repo.Migrations.CreateDataset do
  use Ecto.Migration

  def change do
    create table(:datasets) do
      add :name, :string
      add :title, :string

      timestamps()
    end

  end
end
