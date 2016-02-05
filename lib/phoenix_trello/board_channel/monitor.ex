defmodule PhoenixTrello.BoardChannel.Monitor do
  @moduledoc """
  Board monitor that keeps track of connected users.
  """

  use GenServer

  #####
  # External API

  def create(board_id) do
    case GenServer.whereis(ref(board_id)) do
      nil ->
        Supervisor.start_child(PhoenixTrello.BoardChannel.Supervisor, [board_id])
      _board ->
        {:error, :board_already_exists}
    end
  end

  def start_link(board_id) do
    GenServer.start_link(__MODULE__, [], name: ref(board_id))
  end

  def user_joined(board_id, user) do
   try_call board_id, {:user_joined, user}
  end

  def users_in_board(board_id) do
   try_call board_id, {:users_in_board}
  end

  def user_left(board_id, user) do
    try_call board_id, {:user_left, user}
  end

  #####
  # GenServer implementation

  def handle_call({:user_joined, user}, _from, users) do
    users = [user] ++ users
      |> Enum.uniq

    {:reply, users, users}
  end

  def handle_call({:users_in_board}, _from, users) do
    { :reply, users, users }
  end

  def handle_call({:user_left, user}, _from, users) do
    users = List.delete(users, user)
    {:reply, users, users}
  end

  defp ref(board_id) do
    {:global, {:board, board_id}}
  end

  defp try_call(board_id, call_function) do
    case GenServer.whereis(ref(board_id)) do
      nil ->
        {:error, :invalid_board}
      board ->
        GenServer.call(board, call_function)
    end
  end
end
