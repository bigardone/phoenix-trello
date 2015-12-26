defmodule PhoenixTrello.BoardController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController
  plug :scrub_params, "board" when action in [:create, :update]

  alias PhoenixTrello.Repo
  alias PhoenixTrello.Board

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)
    boards = assoc(current_user, :owned_boards)
      |> Repo.all
      |> Repo.preload(:lists)

    render(conn, "index.json", boards: boards)
  end

  def create(conn, %{"board" => board_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset =
      current_user
      |> build(:owned_boards)
      |> Board.changeset(board_params)

    case Repo.insert(changeset) do
      {:ok, board} ->
        conn
        |> put_status(:created)
        |> render("show.json", board: board)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
