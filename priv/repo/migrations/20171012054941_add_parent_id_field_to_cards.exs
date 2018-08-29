defmodule PhoenixTrello.Repo.Migrations.AddParentIdFieldToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :category, :string
      add :parent_id, :integer
    end
  end
end
