defmodule PhoenixTrello.Factory do
  use ExMachina.Ecto, repo: PhoenixTrello.Repo

  alias PhoenixTrello.{User}

  def factory(:user) do
    %User{
      first_name: sequence(:first_name, &"First #{&1}"),
      last_name: sequence(:last_name, &"Last #{&1}"),
      email: sequence(:email, &"email-#{&1}@foo.com"),
      encrypted_password: "12345678"
    }
  end
end
