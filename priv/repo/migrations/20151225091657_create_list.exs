defmodule PhoenixTrello.Repo.Migrations.CreateList do
  use Ecto.Migration

  def change do
    create table(:lists) do
      add :name, :string, null: false
      add :position, :integer, defaul: 0
      add :board_id, references(:boards, on_delete: :delete_all)

      timestamps
    end

    create index(:lists, [:board_id])
    create index(:lists, [:id, :position], unique: true)
  end
end
