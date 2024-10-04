defmodule RsaComponents.MixProject do
  use Mix.Project

  def project do
    [
      app: :rsa_components,
      version: "0.1.0",
      elixir: "~> 1.17",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

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
      {:phoenix_live_view, "~> 0.20.17"},
      # {:live_select, "~> 1.4.0"},
      {:live_select, github: "ringvold/live_select", branch: "multi-select-tags-mode"},
      # {:live_select, path: "../../live_select"},
      {:gettext, "~> 0.20"},
      {:mix_test_watch, "~> 1.2", only: [:dev, :test]},
      # {:credo, "~> 1.6", only: [:dev, :test], runtime: false},
      # {:styler, "~> 0.7", only: [:dev, :test], runtime: false},
      {:ex_doc, "~> 0.34.1", only: [:dev, :test], runtime: false},
      {:excoveralls, "~> 0.10", only: [:dev, :test], runtime: false},
      {:tailwind, "~> 0.2", only: [:dev, :test], runtime: Mix.env() == :dev}
    ]
  end
end
