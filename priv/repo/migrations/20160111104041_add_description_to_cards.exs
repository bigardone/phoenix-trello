defmodule PhoenixTrello.Repo.Migrations.AddDescriptionToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :description, :text
    end
  end
end
