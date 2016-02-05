defmodule PhoenixTrello.BoardChannel.MonitorTest do
  use ExUnit.Case, async: true

  import PhoenixTrello.Factory

  alias PhoenixTrello.BoardChannel.Monitor

  @board_id "1-board"

  setup_all do
    users = %{
      first_user: create(:user),
      second_user: create(:user),
      third_user: create(:user)
    }

    Monitor.create(@board_id)

    {:ok, %{users: users}}
  end

  test "it adds a user calling :user_joined", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    new_state = Monitor.user_joined(@board_id, users.third_user.id)

    assert new_state == [users.third_user.id, users.second_user.id, users.first_user.id]
  end

  test "it removes a user when calling :user_left", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    new_state = Monitor.user_joined(@board_id, users.third_user.id)
    assert new_state == [users.third_user.id, users.second_user.id, users.first_user.id]

    new_state = Monitor.user_left(@board_id, users.third_user.id)
    assert new_state == [users.second_user.id, users.first_user.id]

    new_state = Monitor.user_left(@board_id, users.second_user.id)
    assert new_state == [users.first_user.id]
  end

  test "it returns the list of users in channel when calling :users_in_board", %{users: users} do
    Monitor.user_joined(@board_id, users.first_user.id)
    Monitor.user_joined(@board_id, users.second_user.id)
    Monitor.user_joined(@board_id, users.third_user.id)

    returned_users = Monitor.users_in_board(@board_id)

    assert returned_users === [users.third_user.id, users.second_user.id, users.first_user.id]
  end
end
