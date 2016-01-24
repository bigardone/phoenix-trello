defmodule PhoenixTrello.SignInTest do
  use PhoenixTrello.IntegrationCase

  test "GET /" do
    navigate_to "/"

    :timer.sleep(5000)

    assert page_title =~ "Sign in"
  end
end
