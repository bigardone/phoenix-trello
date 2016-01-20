defmodule PhoenixTrello.CardMember do
  use PhoenixTrello.Web, :model

  alias __MODULE__

  schema "card_members" do
    belongs_to :card, PhoenixTrello.Card
    belongs_to :user_board, PhoenixTrello.UserBoard
    has_one :user, through: [:user_board, :user]

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
    |> unique_constraint(:user_board_id, name: :card_members_card_id_user_board_id_index)
  end

  def get_by_card_and_user_board(query \\ %CardMember{}, card_id, user_board_id) do
    from cm in query,
    where: cm.card_id == ^card_id and cm.user_board_id == ^user_board_id,
    limit: 1
  end
end
