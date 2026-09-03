defmodule RsaComponents.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsa_components,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      elixirc_paths: elixirc_paths(Mix.env()),
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger]
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:tails, "~> 0.1.5"},
      {:phoenix_live_view, "~> 1.1"},
      # {:live_select, "~> 1.4.0"},
      {:live_select, "~> 1.7"},
      # {:live_select, path: "../../live_select"},
      {:gettext, "~> 0.20 or ~> 1.0"},
      {:mix_test_watch, "~> 1.4", only: [:dev, :test]},
      # {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # {:styler, "~> 0.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.39.3", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test], runtime: false},
      {:floki, ">= 0.30.0", only: :test},
      {:tailwind, "~> 0.2", only: [:dev, :test], runtime: Mix.env() == :dev}
    ]
  end
end
