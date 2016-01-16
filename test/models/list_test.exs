defmodule PhoenixTrello.ListTest do
  use PhoenixTrello.ModelCase, async: true

  import PhoenixTrello.Factory

  alias PhoenixTrello.{Repo, List}

  @valid_attrs %{name: "some content"}
  @invalid_attrs %{}

  setup do
    {:ok, %{board: create(:board)}}
  end

  test "changeset with valid attributes", %{board: board} do
    changeset = List.changeset(%List{board_id: board.id}, @valid_attrs)

    assert changeset.valid?

    list = Repo.insert!(changeset)
    assert list.position == 1024
  end

  test "changeset with invalid attributes", %{board: board} do
    changeset = List.changeset(%List{board_id: board.id}, @invalid_attrs)

    refute changeset.valid?
  end

  test "existing lists for the same board", %{board: board} do
    count = 3

    for i <- 1..(count-1) do
      board
      |> build_assoc(:lists)
      |> List.changeset(%{name: "List #{i}"})
      |> Repo.insert
    end

    {:ok, last_list} = board
      |> build_assoc(:lists)
      |> List.changeset(%{name: "Last"})
      |> Repo.insert

    assert last_list.position == 1024 * count
  end
end
