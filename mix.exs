defmodule ExDate.Mixfile do
  use Mix.Project

  def project do
    [app: :ex_date,
     version: "0.0.1",
     elixir: ">= 0.14.1",
     deps: deps]
  end

  def application do
    [applications: []]
  end

  defp deps do
    []
  end
end
