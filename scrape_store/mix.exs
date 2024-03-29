defmodule ScrapeStore.MixProject do
  use Mix.Project

  def project do
    [
      app: :scrape_store,
      version: "0.1.0",
      elixir: "~> 1.13",
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  # Run "mix help compile.app" to learn about applications.
  def application do
    [
      extra_applications: [:logger],
      mod: {ScrapeStore.Application, []}
    ]
  end

  # Run "mix help deps" to learn about dependencies.
  defp deps do
    [
      {:httpoison, "~> 1.8"},
      {:floki, "~> 0.34.0"},
      {:jason, "~> 1.4"},
      {:raw_sqlite3, "~> 1.0"}
    ]
  end
end
