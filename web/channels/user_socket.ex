defmodule PhoenixTrello.UserSocket do
  use Phoenix.Socket

  alias PhoenixTrello.{Repo, User}

  # Channels
  channel "boards:*", PhoenixTrello.BoardChannel

  # Transports
  transport :websocket, Phoenix.Transports.WebSocket
  transport :longpoll, Phoenix.Transports.LongPoll

  def connect(%{"token" => token}, socket) do
    case Guardian.decode_and_verify(token) do
      {:ok, claims} ->
        user_id = claims["sub"] |> String.replace("User:", "") |> String.to_integer
        user = Repo.get!(User, user_id)

        {:ok, assign(socket, :current_user, user)}
      {:error, _reason} ->
        :error
    end
  end

  def connect(_params, _socket), do: :error

  def id(socket), do: "users_socket:#{socket.assigns.current_user.id}"
end
