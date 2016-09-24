defmodule PhoenixTrello.CardTest do
  use PhoenixTrello.ModelCase

  import PhoenixTrello.Factory

  alias PhoenixTrello.{Card}

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    board = insert(:board, %{user: user})
    list = insert(:list, %{board: board})

    {:ok, list: list}
  end

  test "existing cards for the same list", %{list: list} do
    count = 3

    for i <- 1..(count-1) do
      list
      |> build_assoc(:cards)
      |> Card.changeset(%{name: "Card #{i}"})
      |> Repo.insert
    end

    {:ok, last_card} = list
      |> build_assoc(:cards)
      |> Card.changeset(%{name: "Last"})
      |> Repo.insert

    assert last_card.position == 1024 * count
  end
end
