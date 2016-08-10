defmodule DGUWeb.Repo.Migrations.CreateDataFile do
  use Ecto.Migration

  def change do
    create table(:datafiles) do
      add :name, :string
      add :description, :text
      add :url, :text
      add :format, :string
      add :dataset_id, references(:datasets, on_delete: :nothing)

      timestamps()
    end
    create index(:datafiles, [:dataset_id])

  end
end
