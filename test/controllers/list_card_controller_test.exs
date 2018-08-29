defmodule PhoenixTrello.ListCardControllerTest do
  use PhoenixTrello.ConnCase

  alias PhoenixTrello.ListCard
  @valid_attrs %{}
  @invalid_attrs %{}

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, list_card_path(conn, :index)
    assert html_response(conn, 200) =~ "Listing list cards"
  end

  test "renders form for new resources", %{conn: conn} do
    conn = get conn, list_card_path(conn, :new)
    assert html_response(conn, 200) =~ "New list card"
  end

  test "creates resource and redirects when data is valid", %{conn: conn} do
    conn = post conn, list_card_path(conn, :create), list_card: @valid_attrs
    assert redirected_to(conn) == list_card_path(conn, :index)
    assert Repo.get_by(ListCard, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, list_card_path(conn, :create), list_card: @invalid_attrs
    assert html_response(conn, 200) =~ "New list card"
  end

  test "shows chosen resource", %{conn: conn} do
    list_card = Repo.insert! %ListCard{}
    conn = get conn, list_card_path(conn, :show, list_card)
    assert html_response(conn, 200) =~ "Show list card"
  end

  test "renders page not found when id is nonexistent", %{conn: conn} do
    assert_error_sent 404, fn ->
      get conn, list_card_path(conn, :show, -1)
    end
  end

  test "renders form for editing chosen resource", %{conn: conn} do
    list_card = Repo.insert! %ListCard{}
    conn = get conn, list_card_path(conn, :edit, list_card)
    assert html_response(conn, 200) =~ "Edit list card"
  end

  test "updates chosen resource and redirects when data is valid", %{conn: conn} do
    list_card = Repo.insert! %ListCard{}
    conn = put conn, list_card_path(conn, :update, list_card), list_card: @valid_attrs
    assert redirected_to(conn) == list_card_path(conn, :show, list_card)
    assert Repo.get_by(ListCard, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    list_card = Repo.insert! %ListCard{}
    conn = put conn, list_card_path(conn, :update, list_card), list_card: @invalid_attrs
    assert html_response(conn, 200) =~ "Edit list card"
  end

  test "deletes chosen resource", %{conn: conn} do
    list_card = Repo.insert! %ListCard{}
    conn = delete conn, list_card_path(conn, :delete, list_card)
    assert redirected_to(conn) == list_card_path(conn, :index)
    refute Repo.get(ListCard, list_card.id)
  end
end
