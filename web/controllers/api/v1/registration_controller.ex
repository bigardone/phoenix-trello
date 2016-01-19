defmodule PhoenixTrello.RegistrationController  do
  use PhoenixTrello.Web, :controller

  alias PhoenixTrello.{Repo, User}

  plug :scrub_params, "user" when action in [:create]

  def create(conn, %{"user" => user_params}) do
    changeset = User.changeset(%User{}, user_params)

    case Repo.insert(changeset) do
      {:ok, user} ->
        {:ok, jwt, _full_claims} = user |> Guardian.encode_and_sign(:token)

        conn
        |> put_status(:created)
        |> render(jwt: jwt, user: user)

      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render("error.json", changeset: changeset)
    end
  end
end
