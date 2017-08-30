defmodule Swap.Mixfile do
  use Mix.Project

  @description """
  Tiny library that allows you to swap dependencies in your app. Moreover it
  allows you to inject dependencies with function decorator or with block syntax.
  """

  def project do
    [app: :swap,
     version: "0.1.0",
     elixir: "~> 1.4",
     name: "Swap",
     description: @description,
     package: package(),
     source_url: "https://github.com/madeinussr/swap",
     docs: [extras: ["README.md"]],
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps()]
  end

  def application do
    [extra_applications: [:logger]]
  end

  defp deps do
    [{:decorator, "~> 0.0"}]
  end

  defp package do
    [
      files: ["lib", "mix.exs", "README.md", "LICENSE"],
      maintainers: ["Andrey Chernykh"],
      licenses: ["MIT"],
      links: %{"Github" => "https://github.com/madeinussr/swap"}
    ]
  end
end
