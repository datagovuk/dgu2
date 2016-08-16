defmodule :"Elixir.DGUWeb.Repo.Migrations.Add name and description to upload" do
  use Ecto.Migration

  def change do
    alter table(:uploads) do
      add :name, :string
      add :description, :text
    end

  end
end
