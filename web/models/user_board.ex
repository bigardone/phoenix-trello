defmodule PhoenixTrello.UserBoard do
  use PhoenixTrello.Web, :model

  alias __MODULE__

  schema "user_boards" do
    belongs_to :user, PhoenixTrello.User
    belongs_to :board, PhoenixTrello.Board

    timestamps
  end

  @required_fields ~w(user_id board_id)
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

  def find_by_user_and_board(query \\ %UserBoard{}, user_id, board_id) do
    from u in query,
    where: u.user_id == ^user_id and u.board_id == ^board_id 
  end
end
