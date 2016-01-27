defmodule PhoenixTrello.ShowBoardTest do
  use PhoenixTrello.IntegrationCase

  alias PhoenixTrello.{User, Board}

  setup do
    user = build(:user)
    |> User.changeset(%{password: "12345678"})
    |> Repo.insert!

    board = user
    |> build_assoc(:owned_boards)
    |> Board.changeset(%{name: "My new board"})
    |> Repo.insert!


    {:ok, %{user: user, board: board |> Repo.preload([:user, :invited_users, lists: :cards])}}
  end

  @tag :integration
  test "Clicking on previously created board", %{user: user, board: board} do
    user_sign_in(%{user: user, board: board})

    element_visible? {:id, "authentication_container"}

    assert page_source =~ board.name

    board_id = board
      |> Board.slug_id

    click({:id, board_id})

    element_visible? {:css, ".view-container.boards.show"}

    assert page_title =~ board.name
    assert page_source =~ board.name
    assert page_source =~ "Add new list..."
  end
end
