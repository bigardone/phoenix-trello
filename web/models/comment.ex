defmodule PhoenixTrello.Comment do
  use PhoenixTrello.Web, :model

  @derive {Poison.Encoder, only: [:id, :user, :card_id, :text, :inserted_at]}

  schema "comments" do
    field :text, :string

    belongs_to :user, PhoenixTrello.User
    belongs_to :card, PhoenixTrello.Card

    timestamps
  end

  @required_fields ~w(user_id card_id text)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
