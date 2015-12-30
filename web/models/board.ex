defmodule PhoenixTrello.Board do
  use Ecto.Schema
  import Ecto.Changeset
  import Ecto.Query

  alias __MODULE__

  @derive {Poison.Encoder, only: [:id, :name, :lists, :user, :invited_users]}

  schema "boards" do
    field :name, :string

    belongs_to :user, PhoenixTrello.User
    has_many :lists, PhoenixTrello.List
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

  def for_user(user_id) do
    from board in Board,
    left_join: user_boards in assoc(board, :user_boards),
    where: board.user_id == ^user_id or user_boards.user_id == ^user_id,
    limit: 1
  end
end
