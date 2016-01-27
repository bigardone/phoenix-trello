defmodule PhoenixTrello.Repo.Migrations.AddTagsToCards do
  use Ecto.Migration

  def change do
    alter table(:cards) do
      add :tags, {:array, :string}, default: []
    end

    create index(:cards, [:tags])
  end
end
