defmodule DGUWeb.Repo.Migrations.CreatePossibleLink do
  use Ecto.Migration

  def change do
    create table(:possible_links) do
      add :url, :text
      add :publisher_name, :string

      timestamps()
    end

  end
end
