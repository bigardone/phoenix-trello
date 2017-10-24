defmodule PhoenixTrello.BoardCardTest do
  use PhoenixTrello.ModelCase

  alias PhoenixTrello.BoardCard

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = BoardCard.changeset(%BoardCard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = BoardCard.changeset(%BoardCard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
