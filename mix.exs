defmodule PhoenixTrello.Mixfile do
  use Mix.Project

  def project do
    [app: :phoenix_trello,
     version: "0.0.1",
     elixir: "~> 1.0",
     elixirc_paths: elixirc_paths(Mix.env),
     compilers: [:phoenix] ++ Mix.compilers,
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     aliases: aliases,
     deps: deps]
  end

  # Configuration for the OTP application.
  #
  # Type `mix help compile.app` for more information.
  def application do
    [mod: {PhoenixTrello, []},
     applications: [
      :phoenix,
      :phoenix_pubsub,
      :phoenix_html,
      :cowboy,
      :logger,
      :phoenix_ecto,
      :postgrex,
      :comeonin,
      :ex_machina
    ]]
  end

  # Specifies which paths to compile per environment.
  defp elixirc_paths(:test), do: ["lib", "web", "test/support"]
  defp elixirc_paths(_),     do: ["lib", "web"]

  # Specifies your project dependencies.
  #
  # Type `mix help deps` for examples and options.
  defp deps do
    [
      {:phoenix, "~> 1.2.1"},
      {:phoenix_pubsub, "~> 1.0"},
      {:phoenix_ecto, "~> 3.0.1"},
      {:postgrex, ">= 0.0.0", override: true},
      {:phoenix_html, "~> 2.6.2"},
      {:phoenix_live_reload, "~> 1.0", only: :dev},
      {:cowboy, "~> 1.0"},
      {:comeonin, "~> 2.5.3"},
      {:guardian, "~> 0.13.0"},
      {:credo, "~> 0.4.11", only: [:dev, :test]},
      {:ex_machina, "~> 1.0.2"},
      {:exactor, "~> 2.2.0"},
      {:hound, "~> 1.0.2"},
      {:mix_test_watch, "~> 0.2", only: :dev}
     ]
  end

  # Aliases are shortcut or tasks specific to the current project.
  # For example, to create, migrate and run the seeds file at once:
  #
  #     $ mix ecto.setup
  #
  # See the documentation for `Mix` for more info on aliases.
  defp aliases do
    ["ecto.setup": ["ecto.create", "ecto.migrate", "run priv/repo/seeds.exs"],
     "ecto.reset": ["ecto.drop", "ecto.setup"],
      "test": ["ecto.create --quiet", "ecto.migrate", "test"]]
  end
end
