defmodule DGUWeb.Repo.Migrations.CreatePublisherUser do
  use Ecto.Migration

  def change do
    create table(:publisher_user) do
      add :user_id, references(:users)
      add :publisher_id, references(:publishers)
      add :role, :string 
    end

  end
end
