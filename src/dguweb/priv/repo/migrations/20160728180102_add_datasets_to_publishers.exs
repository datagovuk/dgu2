defmodule DGUWeb.Repo.Migrations.AddDatasetsToPublishers do
  use Ecto.Migration

  def change do
    alter table(:datasets) do
      add :publisher_id, references(:publishers)
    end
  end
end
