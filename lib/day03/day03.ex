defmodule Aoc.Day03 do
  @moduledoc """
  Day 03 Solutions.
  """

  import Aoc.Helpers

  @pattern ~r/mul\((?<foo>\d{1,3})\,(?<bar>\d{1,3})\)/
  @wordpattern ~r/(?<mul>mul\(\d{1,3},\d{1,3}\))|(?<do>do\(\))|(?<dont>don't\(\))/

  def p1,
    do:
      read_input("../inputs/d3.txt")
      |> Enum.flat_map(&Regex.scan(@pattern, &1, capture: :all_names))
      |> sum_poducts()

  def p2 do
    {_state, result} =
      read_input("../inputs/d3.txt")
      |> Enum.flat_map(&Regex.scan(@wordpattern, &1, capture: :all_names))
      |> List.flatten()
      |> just_valid()

    Regex.scan(@pattern, result, capture: :all_names) |> sum_poducts()
  end

  defp just_valid(list) do
    Enum.reduce(list, {true, ""}, fn word, {state, result} ->
      case {state, word} do
        # disable capturing
        {true, "don't()"} -> {false, result}
        # accumulate results
        {true, mul} -> {true, result <> mul}
        # re-enable capturing
        {false, "do()"} -> {true, result}
        # ignore other cases
        {state, _} -> {state, result}
      end
    end)
  end

  defp mult(chars),
    do:
      chars
      |> Enum.map(&String.to_integer/1)
      |> Enum.product()

  defp sum_poducts(list),
    do: Enum.sum(Enum.map(list, &mult/1))
end
