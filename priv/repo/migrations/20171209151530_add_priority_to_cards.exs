defmodule PhoenixTrello.Repo.Migrations.AddPriorityToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :priority, :text
    end
  end
end
