defmodule PhoenixTrello.CardTest do
  use PhoenixTrello.ModelCase

  import PhoenixTrello.Factory

  alias PhoenixTrello.{Card}

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    board = insert(:board, %{user_id: user.id})
    list = insert(:list, %{board_id: board.id})

    {:ok, list: list}
  end

  test "changeset with valid attributes", %{list: list} do
    changeset = Card.changeset(%Card{list_id: list.id}, @valid_attrs)

    assert changeset.valid?
  end

  test "changeset with invalid attributes", %{list: list} do
    changeset = Card.changeset(%Card{list_id: list.id}, @invalid_attrs)

    refute changeset.valid?
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
