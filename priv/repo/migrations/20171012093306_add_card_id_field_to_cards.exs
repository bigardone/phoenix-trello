defmodule PhoenixTrello.Repo.Migrations.AddCardIdFieldToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :card_id, :integer
    end
  end
end
