defmodule PhoenixTrello.CardView do
  use PhoenixTrello.Web, :view

  def render("show.json", %{card: card}) do
    card
  end
end
