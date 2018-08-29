defmodule PhoenixTrello.Repo.Migrations.CreateBoardCard do
  use Ecto.Migration

  def change do
    create table(:board_cards) do
      add :board_id, references(:boards, on_delete: :nothing)
      add :card_id, references(:cards, on_delete: :nothing)

      timestamps()
    end
    create index(:board_cards, [:board_id])
    create index(:board_cards, [:card_id])

  end
end
