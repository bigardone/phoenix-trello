defmodule PhoenixTrello.Repo.Migrations.UpdateBoardsSlugs do
  use Ecto.Migration

  alias PhoenixTrello.{Repo, Board}

  def change do
    
    # try do
    #   Repo.all(Board)
    #   |> Enum.each(fn board ->
    #     slug = board.name
    #       |> String.downcase()
    #       |> String.replace(~r/[^\w-]+/, "-")
    #
    #     Board.changeset(board, %{slug: slug})
    #     |> Repo.update()
    #   end)
    # catch
    #   _,_ -> IO.puts("Error updating boards slugs")
    # end
  end
end
