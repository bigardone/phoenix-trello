defmodule PhoenixTrello.CurrentUserController do
  use PhoenixTrello.Web, :controller

  plug Guardian.Plug.EnsureAuthenticated, handler: PhoenixTrello.SessionController

  def show(conn, _) do
    case decode_and_verify_token(conn) do
      { :ok, _claims } ->
        user = Guardian.Plug.current_resource(conn)

        conn
        |> put_status(:ok)
        |> render("show.json", user: user)

      { :error, _reason } ->
        conn
        |> put_status(:not_found)
        |> render(PhoenixTrello.SessionView, "error.json", error: "Not Found")
    end
  end

  defp decode_and_verify_token(conn)  do
    conn
    |> Guardian.Plug.current_token
    |> Guardian.decode_and_verify
  end
end
