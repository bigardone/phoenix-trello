defmodule PhoenixTrello.ListCard do
  use PhoenixTrello.Web, :model

  schema "list_cards" do
    belongs_to :list, PhoenixTrello.List
    belongs_to :card, PhoenixTrello.Card

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [])
    |> validate_required([])
  end
end
