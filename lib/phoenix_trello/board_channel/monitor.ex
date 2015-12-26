defmodule PhoenixTrello.BoardChannel.Monitor do
  use GenServer

  #####
  # External API

  def start_link(initial_state) do
   GenServer.start_link(__MODULE__, initial_state, name: __MODULE__)
  end

  def user_joined(channel, user) do
   GenServer.call(__MODULE__, {:user_joined, channel, user})
  end

  def users_in_channel(channel) do
   GenServer.call(__MODULE__, {:users_in_channel, channel})
  end

  def user_left(channel, user_id) do
    GenServer.call(__MODULE__, {:user_left, channel, user_id})
  end

  #####
  # GenServer implementation

  def handle_call({:user_joined, channel, user}, _from, state) do
    new_state = case Enum.find(state, fn({x, _value}) -> x == channel  end) do
      {channel, users} ->
        Map.put(state, channel, Enum.uniq([user | users]))
      _ ->
        Map.put(state, channel, [user])
    end

    {:reply, new_state, new_state}
  end

  def handle_call({:users_in_channel, channel}, _from, state) do
    { :reply, state[channel], state }
  end

  def handle_call({:user_left, channel, user_id}, _from, state) do
    new_users = Enum.reject(state[channel], fn user -> user.id == user_id end)

    new_state = state |> Map.delete(channel) |> Map.put(channel, new_users)

    {:reply, new_state, new_state}
  end
end
