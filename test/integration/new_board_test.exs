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
    navigate_to "/"

    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:id, "user_email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:id, "user_password")
    |> fill_field(user.password)

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    element_visible? {:id, "authentication_container"}

    click({:id, "add_new_board"})

    element_visible? {:id, "new_board_form"}

    new_board_form = find_element(:id, "new_board_form")

    new_board_form
    |> find_within_element(:id, "board_name")
    |> fill_field("New board")

    new_board_form
    |> find_within_element(:css, "button")
    |> click

    element_visible? {:css, ".view-container.boards.show"}

    user = user
      |> Repo.preload(:boards)

    board = user.boards
      |> Enum.at(0)

    assert page_title =~ board.name
    assert page_source =~ "New board"
    assert page_source =~ "Add new list..."
  end
end
