defmodule PhoenixTrello.BoardCardControllerTest do
  use PhoenixTrello.ConnCase

  alias PhoenixTrello.BoardCard
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, board_card_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing board cards"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, board_card_path(conn, :new)
    assert html_response(conn, 200) =~ "New board card"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, board_card_path(conn, :create), board_card: @valid_attrs
    assert redirected_to(conn) == board_card_path(conn, :index)
    assert Repo.get_by(BoardCard, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, board_card_path(conn, :create), board_card: @invalid_attrs
    assert html_response(conn, 200) =~ "New board card"
  end

  test "shows chosen resource", %{conn: conn} do
    board_card = Repo.insert! %BoardCard{}
    conn = get conn, board_card_path(conn, :show, board_card)
    assert html_response(conn, 200) =~ "Show board card"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, board_card_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    board_card = Repo.insert! %BoardCard{}
    conn = get conn, board_card_path(conn, :edit, board_card)
    assert html_response(conn, 200) =~ "Edit board card"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    board_card = Repo.insert! %BoardCard{}
    conn = put conn, board_card_path(conn, :update, board_card), board_card: @valid_attrs
    assert redirected_to(conn) == board_card_path(conn, :show, board_card)
    assert Repo.get_by(BoardCard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    board_card = Repo.insert! %BoardCard{}
    conn = put conn, board_card_path(conn, :update, board_card), board_card: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit board card"
  end

  test "deletes chosen resource", %{conn: conn} do
    board_card = Repo.insert! %BoardCard{}
    conn = delete conn, board_card_path(conn, :delete, board_card)
    assert redirected_to(conn) == board_card_path(conn, :index)
    refute Repo.get(BoardCard, board_card.id)
  end
end
