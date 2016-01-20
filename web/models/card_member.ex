defmodule PhoenixTrello.CardMember do
  use PhoenixTrello.Web, :model

  schema "card_members" do
    belongs_to :card, PhoenixTrello.Card
    belongs_to :user_board, PhoenixTrello.UserBoard

    timestamps
  end

  @required_fields ~w(card_id user_board_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
