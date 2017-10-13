defmodule PhoenixTrello.Repo.Migrations.AddIsTeamBoardFieldToBoards do
  use Ecto.Migration

  def change do
    alter table(:boards) do
      add :is_team_board, :boolean, default: false
    end
  end
end
