defmodule PhoenixTrello.SignInTest do
  use PhoenixTrello.IntegrationCase

  alias PhoenixTrello.User

  test "GET /" do
    navigate_to "/"

    assert page_title == "Sign in | Phoenix Trello"
    assert element_displayed?({:id, "sign_in_form"})
  end

  test "Sign in with wrong email/password" do
    set_window_size current_window_handle, 1280, 1024

    navigate_to "/"

    element_visible? {:id, "sign_in_form"}

    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:id, "user_email")
    |> fill_field("incorrect@email.com")

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    element_visible? {:class, "error"}

    assert page_source =~ "Invalid email or password"
  end

  test "Sign in with existing email/password" do
    set_window_size current_window_handle, 1280, 1024

    user = build(:user)
    |> User.changeset(%{password: "12345678"})
    |> Repo.insert!

    navigate_to "/"

    element_visible? {:id, "sign_in_form"}

    sign_in_form = find_element(:id, "sign_in_form")

    sign_in_form
    |> find_within_element(:id, "user_email")
    |> fill_field(user.email)

    sign_in_form
    |> find_within_element(:id, "user_password")
    |> fill_field(user.password)

    sign_in_form
    |> find_within_element(:css, "button")
    |> click

    element_visible? {:id, "authentication_container"}

    assert page_source =~ "#{user.first_name} #{user.last_name}"
    assert page_source =~ "My boards"
  end
end
