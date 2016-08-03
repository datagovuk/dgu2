defmodule DGUWeb.Repo.Migrations.UpdatePublisherModel do
  use Ecto.Migration

  def change do
    alter table(:publishers) do
      add :description, :string
      add :abbreviation, :string 
      add :category, :string 
      add :closed, :boolean 

      add :foi_name, :string
      add :foi_email, :string
      add :foi_web, :string
      add :foi_phone, :string

      add :contact_name, :string
      add :contact_email, :string
      add :contact_phone, :string

    end
  end
end
