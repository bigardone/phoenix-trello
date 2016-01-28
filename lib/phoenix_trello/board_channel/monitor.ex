defmodule PhoenixTrello.BoardChannel.Monitor do
  @moduledoc """
  Board channel monitor that keeps track of connected users per board.
  """
  use ExActor.GenServer, export: :board_channel_monitor

  defstart start_link(n), do: initial_state(n)

  defcall user_joined(channel, user), state: state do
    state = case Map.get(state, channel) do
      nil ->
        state |> Map.put(channel, [user])
      users ->
        state |> Map.put(channel, Enum.uniq([user | users]))
    end

    state
    |> set_and_reply(state)
  end

  defcall users_in_channel(channel), state: state do
    state
    |> Map.get(channel)
    |> reply
  end

  defcall user_left(channel, user_id), state: state do
    new_users = state
      |> Map.get(channel)
      |> Enum.reject(&(&1.id == user_id))

    state = state
    |> Map.update!(channel, fn(_) -> new_users end)

    state
    |> set_and_reply(state)
  end
end
