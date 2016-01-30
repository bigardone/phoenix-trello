defmodule PhoenixTrello.AddListsTest do
  use PhoenixTrello.IntegrationCase

  alias PhoenixTrello.{Board}

  setup do
    user = create_user

    board = user
    |> build_assoc(:owned_boards)
    |> Board.changeset(%{name: "My new board"})
    |> Repo.insert!
    |> Repo.preload([:user, :invited_users, lists: :cards])

    {:ok, %{user: user, board: board }}
  end

  @tag :integration
  test "Clicking on previously created board", %{user: user, board: board} do
    user_sign_in(%{user: user, board: board})

    navigate_to "/boards/#{Board.slug_id(board)}"

    assert element_displayed?({:css, ".view-container.boards.show"})
    assert page_source =~ "Add new list..."

    click {:css, ".list.add-new"}

    assert element_displayed?({:css, ".list.form"})

    new_list_form = find_element(:id, "new_list_form")

    new_list_form
    |> find_within_element(:id, "list_name")
    |> fill_field("New list")

    new_list_form
    |> find_within_element(:css, "button")
    |> click

    list = user
      |> last_list

    assert element_displayed?({:id, "list_#{list.id}"})
  end

  defp last_list(user) do
    user
    |> Repo.preload([boards: [:lists]])
    |> Map.get(:boards)
    |> List.last
    |> Repo.preload(:lists)
    |> Map.get(:lists)
    |> List.last
  end
end
