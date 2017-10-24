defmodule PhoenixTrello.ListCardController do
  use PhoenixTrello.Web, :controller

  alias PhoenixTrello.ListCard

  def index(conn, _params) do
    list_cards = Repo.all(ListCard)
    render(conn, "index.html", list_cards: list_cards)
  end

  def new(conn, _params) do
    changeset = ListCard.changeset(%ListCard{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"list_card" => list_card_params}) do
    changeset = ListCard.changeset(%ListCard{}, list_card_params)

    case Repo.insert(changeset) do
      {:ok, _list_card} ->
        conn
        |> put_flash(:info, "List card created successfully.")
        |> redirect(to: list_card_path(conn, :index))
      {:error, changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    list_card = Repo.get!(ListCard, id)
    render(conn, "show.html", list_card: list_card)
  end

  def edit(conn, %{"id" => id}) do
    list_card = Repo.get!(ListCard, id)
    changeset = ListCard.changeset(list_card)
    render(conn, "edit.html", list_card: list_card, changeset: changeset)
  end

  def update(conn, %{"id" => id, "list_card" => list_card_params}) do
    list_card = Repo.get!(ListCard, id)
    changeset = ListCard.changeset(list_card, list_card_params)

    case Repo.update(changeset) do
      {:ok, list_card} ->
        conn
        |> put_flash(:info, "List card updated successfully.")
        |> redirect(to: list_card_path(conn, :show, list_card))
      {:error, changeset} ->
        render(conn, "edit.html", list_card: list_card, changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    list_card = Repo.get!(ListCard, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(list_card)

    conn
    |> put_flash(:info, "List card deleted successfully.")
    |> redirect(to: list_card_path(conn, :index))
  end
end
