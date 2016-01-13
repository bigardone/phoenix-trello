defmodule PhoenixTrello.Board do
  use PhoenixTrello.Web, :model

  alias __MODULE__
  alias PhoenixTrello.{List, Comment, Card}

  @derive {Poison.Encoder, only: [:id, :name, :lists, :user, :invited_users]}

  schema "boards" do
    field :name, :string

    belongs_to :user, PhoenixTrello.User
    has_many :lists, PhoenixTrello.List
    has_many :cards, through: [:lists, :cards]
    has_many :user_boards, PhoenixTrello.UserBoard
    has_many :invited_users, through: [:user_boards, :user]

    timestamps
  end

  @required_fields ~w(name)
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

  def for_user(query \\ %Board{}, user_id) do
    from board in query,
    left_join: user_boards in assoc(board, :user_boards),
    where: board.user_id == ^user_id or user_boards.user_id == ^user_id,
    limit: 1
  end

  def with_everything(query) do
    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user
    cards_query = from c in Card, order_by: c.position, preload: [comments: ^comments_query]
    lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    from b in query, preload: [:user, :invited_users, lists: ^lists_query]
  end
end
