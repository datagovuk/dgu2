defmodule DGUWeb.Repo.Migrations.UpdatePublisherModel do
  use Ecto.Migration

  def change do
    alter table(:publishers) do
      modify :description, :text
    end
  end
end
