defmodule DonDominio.MixProject do
  use Mix.Project

  def project do
    [
      app: :don_dominio,
      version: "0.1.0",
      elixir: "~> 1.17",
      elixirc_paths: elixirc_paths(Mix.env()),
      start_permanent: Mix.env() == :prod,
      deps: deps()
    ]
  end

  defp elixirc_paths(:test), do: ["lib", "test/support"]
  defp elixirc_paths(_), do: ["lib"]

  def application do
    [
      mod: {DonDominio.Application, []},
      extra_applications: [:logger]
    ]
  end

  defp deps do
    [
      {:tesla, "~> 1.14"},
      {:finch, "~> 0.19"},
      {:decimal, "~> 2.3"},
      {:typed_ecto_schema, "~> 0.4"},
      {:ecto, "~> 3.12"},

      {:bypass, "~> 2.1", only: :test},

      # only for dev
      {:dialyxir, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:credo, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:doctor, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:ex_check, "~> 0.14", only: [:dev, :test], runtime: false},
      {:ex_doc, ">= 0.0.0", only: [:dev, :test], runtime: false},
      {:mix_audit, ">= 0.0.0", only: [:dev, :test], runtime: false}
    ]
  end
end
