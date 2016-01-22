defmodule PhoenixTrello.BoardChannel.MonitorTest do
  use ExUnit.Case, async: true

  import PhoenixTrello.Factory

  alias PhoenixTrello.BoardChannel.Monitor

  setup_all do
    users = %{
      first_user: create(:user),
      second_user: create(:user),
      third_user: create(:user)
    }

    {:ok, %{users: users}}
  end

  test "it adds a user calling :user_joined", %{users: users} do
    Monitor.user_joined("1-foo", users.first_user)
    Monitor.user_joined("1-foo", users.second_user)
    new_state = Monitor.user_joined("1-foo", users.third_user)

    assert new_state == %{"1-foo" => [users.third_user, users.second_user, users.first_user]}
  end

  test "it removes a user when calling :user_left", %{users: users} do
    Monitor.user_joined("1-foo", users.first_user)
    Monitor.user_joined("1-foo", users.second_user)
    new_state = Monitor.user_joined("1-foo", users.third_user)
    assert new_state == %{"1-foo" => [users.third_user, users.second_user, users.first_user]}

    new_state = Monitor.user_left("1-foo", users.third_user.id)
    assert new_state == %{"1-foo" => [users.second_user, users.first_user]}

    new_state = Monitor.user_left("1-foo", users.second_user.id)
    assert new_state == %{"1-foo" => [users.first_user]}
  end

  test "it returns the list of users in channel when calling :users_in_channel", %{users: users} do
    Monitor.user_joined("1-foo", users.first_user)
    Monitor.user_joined("1-foo", users.second_user)
    Monitor.user_joined("1-foo", users.third_user)

    returned_users = Monitor.users_in_channel("1-foo")

    assert returned_users === [users.third_user, users.second_user, users.first_user]
  end
end
