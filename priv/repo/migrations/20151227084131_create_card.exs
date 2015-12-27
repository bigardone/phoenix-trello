defmodule PhoenixTrello.Repo.Migrations.CreateCard do
  use Ecto.Migration

  def change do
    create table(:cards) do
      add :name, :string, null: false
      add :position, :integer, default: 0
      add :list_id, references(:lists, on_delete: :delete_all), null: false

      timestamps
    end

    create index(:cards, [:list_id])
  end
end
