defmodule PhoenixTrello.BoardChannel do
  @moduledoc """
  Board channel
  """

  use PhoenixTrello.Web, :channel

  alias PhoenixTrello.{User, Board, UserBoard, List, Card, Comment, CardMember}
  alias PhoenixTrello.BoardChannel.Monitor

  def join("boards:" <> board_id, _params, socket) do
    current_user = socket.assigns.current_user
    board = get_current_board(socket, board_id)

    send(self, {:after_join, Monitor.user_joined(board_id, current_user)[board_id]})

    {:ok, %{board: board}, assign(socket, :board, board)}
  end

  def handle_info({:after_join, connected_users}, socket) do
    broadcast! socket, "user:joined", %{users: connected_users}
    {:noreply, socket}
  end

  def handle_in("lists:create", %{"list" => list_params}, socket) do
    board = socket.assigns.board

    changeset = board
      |> build_assoc(:lists)
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

  def handle_in("cards:create", %{"card" => card_params}, socket) do
    board = socket.assigns.board
    list = board
      |> assoc(:lists)
      |> Repo.get!(card_params["list_id"])

    changeset =
      list
      |> build_assoc(:cards)
      |> Card.changeset(card_params)

    case Repo.insert(changeset) do
      {:ok, card} ->
        card = socket.assigns.board
          |> assoc(:cards)
          |> Card.preload_all
          |> Repo.get!(card.id)

        broadcast! socket, "card:created", %{card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating card"}}, socket}
    end
  end

  def handle_in("members:add", %{"email" => email}, socket) do
    try do
      board = socket.assigns.board
      user = User
        |> Repo.get_by(email: email)

      changeset = user
      |> build_assoc(:user_boards)
      |> UserBoard.changeset(%{board_id: board.id})

      case Repo.insert(changeset) do
        {:ok, _board_user} ->
          broadcast! socket, "member:added", %{user: user}

          PhoenixTrello.Endpoint.broadcast_from! self(), "users:#{user.id}", "projects:add", %{board: board}

          {:noreply, socket}
        {:error, _changeset} ->
          {:reply, {:error, %{error: "Error adding new member"}}, socket}
      end
    catch
      _, _-> {:reply, {:error, %{error: "User does not exist"}}, socket}
    end
  end

  def handle_in("card:update", %{"card" => card_params}, socket) do
    card = socket.assigns.board
      |> assoc(:cards)
      |> Repo.get!(card_params["id"])

    changeset = Card.update_changeset(card, card_params)

    case Repo.update(changeset) do
      {:ok, card} ->
        board = get_current_board(socket)

        card = Card
        |> Card.preload_all
        |> Repo.get(card.id)

        broadcast! socket, "card:updated", %{board: board, card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error updating card"}}, socket}
    end
  end

  def handle_in("list:update", %{"list" => list_params}, socket) do
    list = socket.assigns.board
      |> assoc(:lists)
      |> Repo.get!(list_params["id"])

    changeset = List.update_changeset(list, list_params)

    case Repo.update(changeset) do
      {:ok, _list} ->
        board = get_current_board(socket)
        broadcast! socket, "list:updated", %{board: board}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error updating list"}}, socket}
    end
  end

  def handle_in("card:add_comment", %{"card_id" => card_id, "text" => text}, socket) do
    current_user = socket.assigns.current_user

    comment = socket.assigns.board
      |> assoc(:cards)
      |> Repo.get!(card_id)
      |> build_assoc(:comments)

    changeset = Comment.changeset(comment, %{text: text, user_id: current_user.id})

    case Repo.insert(changeset) do
      {:ok, _comment} ->
        card = Card
        |> Card.preload_all
        |> Repo.get(card_id)

        broadcast! socket, "comment:created", %{board: get_current_board(socket), card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating comment"}}, socket}
    end
  end

  def handle_in("card:add_member", %{"card_id" => card_id, "user_id" => user_id}, socket) do
    try do
      current_board = socket.assigns.board

      card_member = current_board
        |> assoc(:cards)
        |> Repo.get!(card_id)
        |> build_assoc(:card_members)

      user_board = UserBoard
        |> UserBoard.find_by_user_and_board(user_id, current_board.id)
        |> Repo.one!()

      changeset = CardMember.changeset(card_member, %{user_board_id: user_board.id})

      case Repo.insert(changeset) do
        {:ok, _} ->
          card = Card
          |> Card.preload_all
          |> Repo.get(card_id)

          broadcast! socket, "card:updated", %{board: get_current_board(socket), card: card}
          {:noreply, socket}
        {:error, _} ->
          {:reply, {:error, %{error: "Error adding new member"}}, socket}
      end
    catch
      _, _-> {:reply, {:error, %{error: "Member does not exist"}}, socket}
    end
  end

  def handle_in("card:remove_member", %{"card_id" => card_id, "user_id" => user_id}, socket) do
    current_board = socket.assigns.board

    user_board = UserBoard
      |> UserBoard.find_by_user_and_board(user_id, current_board.id)
      |> Repo.one!

    card_member = CardMember
      |> CardMember.get_by_card_and_user_board(card_id, user_board.id)
      |> Repo.one!

    case Repo.delete(card_member) do
      {:ok, _} ->
        card = Card
        |> Card.preload_all
        |> Repo.get(card_id)

        broadcast! socket, "card:updated", %{board: get_current_board(socket), card: card}
        {:noreply, socket}
      {:error, _changeset} ->
        {:reply, {:error, %{error: "Error creating comment"}}, socket}
    end
  end

  def terminate(_reason, socket) do
    board_id = Board.slug_id(socket.assigns.board)
    user_id = socket.assigns.current_user.id

    broadcast! socket, "user:left", %{users: Monitor.user_left(board_id, user_id)[board_id]}

    :ok
  end

  defp get_current_board(socket, board_id) do
    socket.assigns.current_user
    |> assoc(:boards)
    |> Board.preload_all
    |> Repo.get(board_id)
  end

  defp get_current_board(socket), do: get_current_board(socket, socket.assigns.board.id)
end
