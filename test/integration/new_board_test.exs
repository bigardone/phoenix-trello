defmodule PhoenixTrello.NewBoardTest do
  use PhoenixTrello.IntegrationCase

  setup do
    user = create_user

    {:ok, %{user: user}}
  end

  @tag :integration
  test "GET / with existing user", %{user: user} do
    user_sign_in(%{user: user})

    click({:id, "add_new_board"})

    assert element_displayed?({:id, "new_board_form"})

    new_board_form = find_element(:id, "new_board_form")

    new_board_form
    |> find_within_element(:id, "board_name")
    |> fill_field("New board")

    new_board_form
    |> find_within_element(:css, "button")
    |> click

    assert element_displayed?({:css, ".view-container.boards.show"})

    board = last_board(user)

    assert page_title =~ board.name
    assert page_source =~ "New board"
    assert page_source =~ "Add new list..."
  end

  def last_board(user) do
    user
    |> Repo.preload(:boards)
    |> Map.get(:boards)
    |> Enum.at(0)
  end
end
