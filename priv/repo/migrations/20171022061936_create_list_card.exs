defmodule PhoenixTrello.Repo.Migrations.CreateListCard do
  use Ecto.Migration

  def change do
    create table(:list_cards) do
      add :list_id, references(:lists, on_delete: :nothing)
      add :card_id, references(:cards, on_delete: :nothing)

      timestamps()
    end
    create index(:list_cards, [:list_id])
    create index(:list_cards, [:card_id])

  end
end
