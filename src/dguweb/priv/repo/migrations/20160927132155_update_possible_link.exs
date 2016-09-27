defmodule DGUWeb.Repo.Migrations.CreatePossibleLink do
  use Ecto.Migration

  def change do
    alter table(:possible_links) do
      add :processed, :boolean
    end

  end
end
