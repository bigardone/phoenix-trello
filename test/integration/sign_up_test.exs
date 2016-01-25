defmodule PhoenixTrello.SignUpTest do
  use PhoenixTrello.IntegrationCase

  @tag :integration
  test "GET /sign_up" do
    navigate_to "/sign_up"

    assert page_title == "Sign up | Phoenix Trello"
    assert element_displayed?({:id, "sign_up_form"})
  end

  @tag :integration
  test "Siginig up with correct data" do
    set_window_size current_window_handle, 1280, 1024

    navigate_to "/sign_up"

    element_visible? {:id, "sign_up_form"}

    sign_up_form = find_element(:id, "sign_up_form")

    sign_up_form
    |> find_within_element(:id, "user_first_name")
    |> fill_field("John")

    sign_up_form
    |> find_within_element(:id, "user_last_name")
    |> fill_field("Doe")

    sign_up_form
    |> find_within_element(:id, "user_email")
    |> fill_field("john@doe.com")

    sign_up_form
    |> find_within_element(:id, "user_password")
    |> fill_field("12345678")

    sign_up_form
    |> find_within_element(:id, "user_password_confirmation")
    |> fill_field("12345678")

    sign_up_form
    |> find_within_element(:css, "button")
    |> click

    element_visible? {:id, "authentication_container"}

    assert page_source =~ "John Doe"
    assert page_source =~ "My boards"
  end
end
