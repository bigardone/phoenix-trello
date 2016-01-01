defmodule PhoenixTrello.Card do
  use Ecto.Schema

  import Ecto.Changeset
  import Ecto.Query, only: [from: 2]

  alias PhoenixTrello.Repo
  alias PhoenixTrello.List
  alias PhoenixTrello.Card

  @derive {Poison.Encoder, only: [:id, :list_id, :name, :position]}

  schema "cards" do
    field :name, :string
    field :position, :integer

    belongs_to :list, List

    timestamps
  end

  @required_fields ~w(name list_id)
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

  def update_changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end

  defp calculate_position(changeset) do
    model = changeset.model

    query = from(c in Card,
            select: c.position,
            where: c.list_id == ^(model.list_id),
            order_by: [desc: c.position],
            limit: 1)

    case Repo.one(query) do
      nil      -> put_change(changeset, :position, 1024)
      position -> put_change(changeset, :position, position + 1024)
    end
  end
end
