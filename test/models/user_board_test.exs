defmodule PhoenixTrello.UserBoardTest do
  use PhoenixTrello.ModelCase

  import PhoenixTrello.Factory

  alias PhoenixTrello.UserBoard

  @valid_attrs %{}
  @invalid_attrs %{}

  setup do
    user = insert(:user)
    board = insert(:board)

    {:ok, user: user, board: board}
  end

  test "changeset with valid attributes", %{user: user, board: board} do
    attributes = @valid_attrs
      |> Map.put(:user_id, user.id)
      |> Map.put(:board_id, board.id)

    changeset = UserBoard.changeset(%UserBoard{}, attributes)
    assert changeset.valid?
  end

  test "changeset with invalid attributes", _ do
    changeset = UserBoard.changeset(%UserBoard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
