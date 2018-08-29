defmodule PhoenixTrello.ListCardTest do
  use PhoenixTrello.ModelCase

  alias PhoenixTrello.ListCard

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = ListCard.changeset(%ListCard{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = ListCard.changeset(%ListCard{}, @invalid_attrs)
    refute changeset.valid?
  end
end
