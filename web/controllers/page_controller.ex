defmodule PhoenixTrello.PageController do
  use PhoenixTrello.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
