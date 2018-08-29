defmodule PhoenixTrello.Repo.Migrations.AddBoardIdToCards do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :board_id, :integer
    end
  end
end
