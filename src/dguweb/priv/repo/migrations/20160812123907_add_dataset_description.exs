defmodule DGUWeb.Repo.Migrations.AddDatasetDescription do
  use Ecto.Migration

  def change do
    alter table(:datasets) do
      add :description, :text
    end
  end
end
