defmodule PhoenixTrello.UserChannel do
  use PhoenixTrello.Web, :channel

  def join("users:" <> user_id, _params, socket) do
    current_user = socket.assigns.current_user

    cond do
      String.to_integer(user_id) == current_user.id -> {:ok, socket}
      true -> {:error, %{}}
    end
  end
end
