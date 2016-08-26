defmodule DGUWeb.Repo.Migrations.RemoveUnusedTables do
  use Ecto.Migration

  def change do
    drop table(:datafiles)
    drop table(:datasets)
    drop table(:publisher_user)
    drop table(:publishers)
  end
end
