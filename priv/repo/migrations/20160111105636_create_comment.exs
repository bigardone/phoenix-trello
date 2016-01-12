defmodule PhoenixTrello.Repo.Migrations.CreateComment do
  use Ecto.Migration

  def change do
    create table(:comments) do
      add :text, :string, null: false
      add :user_id, references(:users, on_delete: :delete_all)
      add :card_id, references(:cards, on_delete: :delete_all)

      timestamps
    end
    
    create index(:comments, [:user_id])
    create index(:comments, [:card_id])
  end
end
