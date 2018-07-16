defmodule Swap.Mixfile do
  use Mix.Project

  @description """
  The library that allows you to swap dependencies in your app.
  Also it allows you to inject dependencies with function decorator.
  """

  def project do
    [app: :swap,
     version: "1.1.1",
     elixir: ">= 1.5.0",
     name: "Swap",
     description: @description,
     package: package(),
     source_url: "https://github.com/madeinussr/swap",
     docs: [extras: ["README.md"]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps(),
     elixirc_paths: elixirc_paths(Mix.env)]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:ex_doc, "~> 0.16", only: [:dev, :test, :docs]}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Andrey Chernykh"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/madeinussr/swap"}
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/fixtures"]
  defp elixirc_paths(_),     do: ["lib"]
end
