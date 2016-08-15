defmodule DGUWeb.Repo.Migrations.CreateUpload do
  use Ecto.Migration

  def change do
    create table(:uploads) do
      add :url, :string
      add :dataset, :string
      add :publisher, :string
      add :content_type, :string
      add :path, :string
      add :warnings, {:array, :string}
      add :errors, {:array, :string}

      timestamps()
    end

  end
end
