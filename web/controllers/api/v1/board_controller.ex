defmodule PhoenixTrello.BoardController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController
  plug :scrub_params, "board" when action in [:create, :update]

  alias PhoenixTrello.Repo
  alias PhoenixTrello.Board

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    owned_boards = assoc(current_user, :owned_boards)
      |> Repo.all
      |> Repo.preload([lists: :cards])

    invited_boards = assoc(current_user, :invited_boards)
      |> Repo.all
      |> Repo.preload([lists: :cards])

    render(conn, "index.json", owned_boards: owned_boards, invited_boards: invited_boards)
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
        |> render("show.json", board: board |> Repo.preload(:lists))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
