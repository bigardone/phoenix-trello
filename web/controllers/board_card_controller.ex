defmodule PhoenixTrello.BoardCardController do
  use PhoenixTrello.Web, :controller

  alias PhoenixTrello.BoardCard

  def index(conn, _params) do
    board_cards = Repo.all(BoardCard)
    render(conn, "index.html", board_cards: board_cards)
  end

  def new(conn, _params) do
    changeset = BoardCard.changeset(%BoardCard{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"board_card" => board_card_params}) do
    changeset = BoardCard.changeset(%BoardCard{}, board_card_params)

    case Repo.insert(changeset) do
      {:ok, _board_card} ->
        conn
        |> put_flash(:info, "Board card created successfully.")
        |> redirect(to: board_card_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    board_card = Repo.get!(BoardCard, id)
    render(conn, "show.html", board_card: board_card)
  end

  def edit(conn, %{"id" => id}) do
    board_card = Repo.get!(BoardCard, id)
    changeset = BoardCard.changeset(board_card)
    render(conn, "edit.html", board_card: board_card, changeset: changeset)
  end

  def update(conn, %{"id" => id, "board_card" => board_card_params}) do
    board_card = Repo.get!(BoardCard, id)
    changeset = BoardCard.changeset(board_card, board_card_params)

    case Repo.update(changeset) do
      {:ok, board_card} ->
        conn
        |> put_flash(:info, "Board card updated successfully.")
        |> redirect(to: board_card_path(conn, :show, board_card))
      {:error, changeset} ->
        render(conn, "edit.html", board_card: board_card, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    board_card = Repo.get!(BoardCard, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(board_card)

    conn
    |> put_flash(:info, "Board card deleted successfully.")
    |> redirect(to: board_card_path(conn, :index))
  end
end
