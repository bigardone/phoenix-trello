defmodule PhoenixTrello.Repo.Migrations.UserPasswordFix do
  use Ecto.Migration

  def change do
    rename table(:users), :crypted_password, to: :encrypted_password
  end
end
