defmodule PhoenixTrello.BoardView do
  use PhoenixTrello.Web, :view

  def render("index.json", %{owned_boards: owned_boards, invited_boards: invited_boards}) do
    %{owned_boards: owned_boards, invited_boards: invited_boards}
  end

  def render("show.json", %{board: board}) do
    board
  end

  def render("error.json", %{changeset: changeset}) do
    errors = Enum.map(changeset.errors, fn {field, detail} ->
      %{} |> Map.put(field, detail)
    end)

    %{
      errors: errors
    }
  end

  def render("file_error.json", _params) do
    %{
      errors: [
        %{
          file: "Invalid file"
        }
      ]
    }
  end
end
