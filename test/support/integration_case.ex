defmodule PhoenixTrello.IntegrationCase do
  use ExUnit.CaseTemplate

  using do
    quote do
      use Hound.Helpers

      import Ecto.Model
      import Ecto.Query, only: [from: 2]
      import PhoenixTrello.Router.Helpers

      alias PhoenixTrello.Repo

      # The default endpoint for testing
      @endpoint PhoenixTrello.Endpoint

      hound_session
    end
  end

  setup tags do
    unless tags[:async] do
      Ecto.Adapters.SQL.restart_test_transaction(PhoenixTrello.Repo, [])
    end

    :ok
  end
end
