defmodule DummyCredo.MixProject do
  use Mix.Project

  def project do
    [
      app: :dummy_credo,
      version: version(),
      elixir: "~> 1.14",
      start_permanent: Mix.env() == :prod,
      deps: deps(),
      description: description(),
      name: "Dummy Credo",
      package: package(),
      docs: docs(),
      source_url: "https://github.com/jsolana/my_credo"
    ]
  end

  @version "0.1.0"

  defp version, do: @version

  defp description do
    "Dummy credo rules for elixir: One lib to rule them all, one lib to find them, one lib to bring them all and in the code correctness bind them"
  end

  defp package do
    %{
      licenses: [],
      links: %{"GitHub" => "https://github.com/jsolana/my_credo"},
      files: [
        "lib",
        ".formatter.exs",
        "mix.exs",
        "README*",
        "config"
      ]
    }
  end

  defp docs do
    [
      # The main page in the docs
      main: "readme",
      # logo: "guides/logo.png",
      extras: ["README.md"],
      source_ref: "v#{@version}",
      source_url: "https://github.com/jsolana/my_credo"
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
      {:credo, "~> 1.7"},
      {:ex_doc, "~> 0.30", only: :dev, runtime: false}
    ]
  end
end
