defmodule PhoenixTrello.BoardController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController
  plug :scrub_params, "board" when action in [:create]

  alias PhoenixTrello.{Repo, Board, UserBoard}

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    owned_boards = current_user
      |> assoc(:owned_boards)
      |> Board.preload_all
      |> Repo.all

    invited_boards = current_user
      |> assoc(:boards)
      |> Board.not_owned_by(current_user.id)
      |> Board.preload_all
      |> Repo.all

    render(conn, "index.json", owned_boards: owned_boards, invited_boards: invited_boards)
  end

  def create(conn, %{"board" => board_params}) do
    current_user = Guardian.Plug.current_resource(conn)

    changeset = current_user
      |> build_assoc(:owned_boards)
      |> Board.changeset(board_params)

    if changeset.valid? do
      board = Repo.insert!(changeset)

      board
      |> build_assoc(:user_boards)
      |> UserBoard.changeset(%{user_id: current_user.id})
      |> Repo.insert!

      conn
      |> put_status(:created)
      |> render("show.json", board: board )
    else
      conn
      |> put_status(:unprocessable_entity)
      |> render("error.json", changeset: changeset)
    end
  end
end
