defmodule PhoenixTrello.BoardChannel do
  require Logger

  use PhoenixTrello.Web, :channel

  alias PhoenixTrello.Repo
  alias PhoenixTrello.User
  alias PhoenixTrello.Board
  alias PhoenixTrello.UserBoard
  alias PhoenixTrello.List
  alias PhoenixTrello.Card
  alias PhoenixTrello.BoardChannel.Monitor

  def join("boards:" <> board_id, _params, socket) do
    current_user = socket.assigns.current_user
    board = get_current_board(board_id, socket)

    send(self, {:after_join, Monitor.user_joined(board_id, current_user)[board_id]})

    {:ok, %{board: board}, assign(socket, :board, board)}
  end

  def handle_info({:after_join, connected_users}, socket) do
    broadcast! socket, "user:joined", %{users: connected_users}
    {:noreply, socket}
  end

  def handle_in("create_list", %{"list" => list_params}, socket) do
    board = socket.assigns.board

    changeset =
      board
      |> build(:lists)
      |> List.changeset(list_params)

    case Repo.insert(changeset) do
      {:ok, list} ->
        list = Repo.preload(list, [:board, :cards])

        broadcast! socket, "list:created", %{list: list}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating list"}}, socket}
    end
  end

  def handle_in("create_card", %{"card" => card_params}, socket) do
    board = socket.assigns.board
    list = board
      |> assoc(:lists)
      |> Repo.get!(card_params["list_id"])

    changeset =
      list
      |> build(:cards)
      |> Card.changeset(card_params)

    case Repo.insert(changeset) do
      {:ok, card} ->
        Repo.preload(card, :list)

        broadcast! socket, "card:created", %{card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating card"}}, socket}
    end
  end

  def handle_in("add_new_member", %{"email" => email}, socket) do
    try do
      board = socket.assigns.board
      user = User.by_email(email)
        |> Repo.one

      if user do
        changeset = user
        |> build(:user_boards)
        |> UserBoard.changeset(%{board_id: board.id})

        case Repo.insert(changeset) do
          {:ok, _board_user} ->
            broadcast! socket, "member:added", %{user: user}
            {:noreply, socket}
          _ ->
            {:reply, {:error, %{error: "Error adding new member"}}, socket}
        end
      end
    catch
      _, _-> {:reply, {:error, %{error: "Error adding new member"}}, socket}
    end

    {:noreply, socket}
  end

  def handle_in("cards:update", %{"card" => card_params}, socket) do
    card = socket.assigns.board
      |> assoc(:cards)
      |> Repo.get!(card_params["id"])

    changeset = Card.update_changeset(card, card_params)

    case Repo.update(changeset) do
      {:ok, _card} ->
        board = get_current_board(socket.assigns.board.id, socket)
        broadcast! socket, "card:updated", %{board: board}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error updating card"}}, socket}
    end
  end

  def terminate(_reason, socket) do
    board_id = to_string(socket.assigns.board.id)
    user_id = socket.assigns.current_user.id

    broadcast! socket, "user:left", %{users: Monitor.user_left(board_id, user_id)[board_id]}

    :ok
  end

  defp get_current_board(board_id, socket) do
    current_user = socket.assigns.current_user

    cards_query = from c in Card, order_by: c.position
    lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    Board.for_user(current_user.id)
      |> Repo.get(board_id)
      |> Repo.preload([:user, :invited_users, lists: lists_query])
  end
end
