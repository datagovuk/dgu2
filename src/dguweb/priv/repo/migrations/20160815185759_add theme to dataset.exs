defmodule :"Elixir.DGUWeb.Repo.Migrations.Add theme to dataset" do
  use Ecto.Migration

  def change do
    alter table(:datasets) do
      add  :theme_id, references(:themes, on_delete: :nothing)
    end
  end

end
