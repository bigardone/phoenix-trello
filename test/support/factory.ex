defmodule PhoenixTrello.Factory do
  use ExMachina.Ecto, repo: PhoenixTrello.Repo

  alias PhoenixTrello.{User, Board, List}

  def factory(:user) do
    %User{
      first_name: sequence(:first_name, &"First #{&1}"),
      last_name: sequence(:last_name, &"Last #{&1}"),
      email: sequence(:email, &"email-#{&1}@foo.com"),
      encrypted_password: "12345678"
    }
  end

  def factory(:board) do
    %Board{
      name: sequence(:name, &"Name #{&1}"),
      user: build(:user)
    }
  end

  def factory(:board_with_lists) do
    %Board{
      name: sequence(:name, &"Name #{&1}"),
      user: build(:user),
      lists: build_list(3, :list)
    }
  end

  def factory(:list) do
    list = %List{
      name: sequence(:name, &"Name #{&1}")
    }
  end
end
