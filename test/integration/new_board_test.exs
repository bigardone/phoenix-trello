defmodule PhoenixTrello.NewBoardTest do
  use PhoenixTrello.IntegrationCase

  alias PhoenixTrello.{User}

  setup do
    user = build(:user)
    |> User.changeset(%{password: "12345678"})
    |> Repo.insert!

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

    user = user
      |> Repo.preload(:boards)

    board = user.boards
      |> Enum.at(0)

    assert page_title =~ board.name
    assert page_source =~ "New board"
    assert page_source =~ "Add new list..."
  end
end
