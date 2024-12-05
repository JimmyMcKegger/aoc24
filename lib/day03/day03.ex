defmodule Aoc.Day03 do
  @moduledoc """
  Day 03 Solutions.
  """

  alias Aoc.Helpers

  @pattern ~r/mul\((?<foo>\d{1,3})\,(?<bar>\d{1,3})\)/

  def p1,
    do:
      Helpers.read_input("../inputs/d3.txt")
      |> Enum.flat_map(&Regex.scan(@pattern, &1, capture: :all_names))
      |> Enum.map(&mult/1)
      |> Enum.sum()

  defp mult(chars),
    do:
      chars
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()
end
