defmodule PhoenixTrello.Repo.Migrations.AddPriorityToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :priority, :boolean, null: false
    end
  end
end
