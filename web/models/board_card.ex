defmodule PhoenixTrello.BoardCard do
  use PhoenixTrello.Web, :model

  schema "board_cards" do
    belongs_to :board, PhoenixTrello.Board
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
