defmodule PhoenixTrello.UserChannel do
  use PhoenixTrello.Web, :channel

  def join("users:" <> user_id, _params, socket) when user_id != "" do
    current_user = socket.assigns.current_user

    if String.to_integer(user_id) == current_user.id do
      {:ok, socket}
    else
      {:error, %{reason: "Invalid user"}}
    end
  end

  def join(_, _params, socket), do: {:error, %{reason: "Invalid user"}}
end
