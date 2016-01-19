defmodule PhoenixTrello.CardController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController

  alias PhoenixTrello.{Repo, Board, Card}

  def show(conn, %{"board_id" => board_id, "id" => id}) do
    current_user = Guardian.Plug.current_resource(conn)

    card = Board
      |> Board.for_user(current_user.id)
      |> Repo.get(board_id)
      |> assoc(:cards)
      |> Card.with_comments
      |> Repo.get!(id)


    render(conn, "show.json", card: card)
  end
end
