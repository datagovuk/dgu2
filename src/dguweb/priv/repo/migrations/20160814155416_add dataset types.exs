defmodule :"Elixir.DGUWeb.Repo.Migrations.Add dataset types" do
  use Ecto.Migration

  def change do
    alter table(:datasets) do
      add :type, :string
    end
  end
end
