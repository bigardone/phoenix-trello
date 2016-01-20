defmodule PhoenixTrello.CardMemberTest do
  use PhoenixTrello.ModelCase

  alias PhoenixTrello.CardMember

  @valid_attrs %{card_id: 1, user_board_id: 1}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = CardMember.changeset(%CardMember{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = CardMember.changeset(%CardMember{}, @invalid_attrs)
    refute changeset.valid?
  end
end
