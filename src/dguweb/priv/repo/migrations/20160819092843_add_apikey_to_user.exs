defmodule DGUWeb.Repo.Migrations.AddApikeyToUser do
  use Ecto.Migration

  def change do
    alter table(:users) do
      add  :apikey, :string
    end
  end
end
