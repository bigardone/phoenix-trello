defmodule PhoenixTrello.BoardController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController
  plug :scrub_params, "board" when action in [:create]

  alias PhoenixTrello.{Repo, Board}

  def index(conn, _params) do
    current_user = Guardian.Plug.current_resource(conn)

    owned_boards = current_user
      |> assoc(:owned_boards)
      |> Board.with_everything
      |> Repo.all

    invited_boards = current_user
      |> assoc(:boards)
      |> Board.not_owned_by(current_user.id)
      |> Board.with_everything
      |> Repo.all

    render(conn, "index.json", owned_boards: owned_boards, invited_boards: invited_boards)
  end

  def create(conn, %{"board" => board_params}) do
    current_user = Guardian.Plug.current_resource(conn)
    changeset =
      current_user
      |> build_assoc(:owned_boards)
      |> Board.changeset(board_params)

    case Repo.insert(changeset) do
      {:ok, board} ->
        conn
        |> put_status(:created)
        |> render("show.json", board: board |> Repo.preload([:user, :invited_users, lists: :cards]))
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
