defmodule PhoenixTrello.Board do
  use PhoenixTrello.Web, :model

  alias __MODULE__
  alias PhoenixTrello.{Repo, Permalink, List, Comment, Card, UserBoard, User}

  @primary_key {:id, Permalink, autogenerate: true}

  schema "boards" do
    field :name, :string
    field :slug, :string

    belongs_to :user, User
    has_many :lists, List
    has_many :cards, through: [:lists, :cards]
    has_many :user_boards, UserBoard
    has_many :members, through: [:user_boards, :user]

    timestamps
  end

  @required_fields ~w(name user_id)
  @optional_fields ~w(slug)

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ %{}) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> slugify_name()
  end

  def not_owned_by(query \\ %Board{}, user_id) do
    from b in query,
    where: b.user_id != ^user_id
  end

  def preload_all(query) do
    comments_query = from c in Comment, order_by: [desc: c.inserted_at], preload: :user
    cards_query = from c in Card, order_by: c.position, preload: [[comments: ^comments_query], :members]
    lists_query = from l in List, order_by: l.position, preload: [cards: ^cards_query]

    from b in query, preload: [:user, :members, lists: ^lists_query]
  end

  def slug_id(board) do
    "#{board.id}-#{board.slug}"
  end

  defp slugify_name(current_changeset) do
    if name = get_change(current_changeset, :name) do
      put_change(current_changeset, :slug, slugify(name))
    else
      current_changeset
    end
  end

  defp slugify(value) do
    value
    |> String.downcase()
    |> String.replace(~r/[^\w-]+/, "-")
  end
end

defimpl Phoenix.Param, for: Board do
  def to_param(%{slug: slug, id: id}) do
    "#{id}-#{slug}"
  end
end

defimpl Poison.Encoder, for: PhoenixTrello.Board do
  def encode(model, options) do
    model
    |> Map.take([:name, :lists, :user, :members])
    |> Map.put(:id, PhoenixTrello.Board.slug_id(model))
    |> Poison.Encoder.encode(options)
  end
end
