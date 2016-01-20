defmodule PhoenixTrello.Repo.Migrations.CreateCardMember do
  use Ecto.Migration

  def change do
    create table(:card_members) do
      add :card_id, references(:cards, on_delete: :delete_all), null: false
      add :user_board_id, references(:user_boards, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:card_members, [:card_id])
    create index(:card_members, [:user_board_id])
    create unique_index(:card_members, [:card_id, :user_board_id])
  end
end
