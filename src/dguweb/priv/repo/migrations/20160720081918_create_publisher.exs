defmodule DGUWeb.Repo.Migrations.CreatePublisher do
  use Ecto.Migration

  def change do
    create table(:publishers) do
      add :name, :string
      add :title, :string
      add :url, :string

      timestamps()
    end

  end
end
