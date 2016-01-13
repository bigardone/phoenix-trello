defmodule PhoenixTrello.UserTest do
  use PhoenixTrello.ModelCase

  alias PhoenixTrello.User

  @valid_attrs %{encrypted_password: "some content", email: "some content", first_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = User.changeset(%User{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = User.changeset(%User{}, @invalid_attrs)
    refute changeset.valid?
  end
end
