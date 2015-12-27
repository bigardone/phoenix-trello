defmodule PhoenixTrello.List do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias PhoenixTrello.Board
  alias PhoenixTrello.Repo
  alias PhoenixTrello.List
  alias PhoenixTrello.Card

  @derive {Poison.Encoder, only: [:id, :name, :cards]}

  schema "lists" do
    field :name, :string
    field :position, :integer

    belongs_to :board, Board
    has_many :cards, Card

    timestamps
  end

  @required_fields ~w(name)
  @optional_fields ~w(position)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> calculate_position()
  end

  defp calculate_position(changeset) do
    model = changeset.model

    query = from(l in List,
            select: l.position,
            where: l.board_id == ^(model.board_id),
            order_by: [desc: l.position],
            limit: 1)

    case Repo.one(query) do
      nil      -> put_change(changeset, :position, 1024)
      position -> put_change(changeset, :position, position + 1024)
    end
  end
end
