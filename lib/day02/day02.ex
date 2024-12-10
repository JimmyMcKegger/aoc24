defmodule Aoc.Day02 do
  @moduledoc """
  Day 02 Solutions.
  """
  import Aoc.Helpers

  def p1,
    do:
      Stream.filter(input_levels(), &safety_check/1)
      |> Enum.count()

  def p2,
    do:
      Enum.filter(input_levels(), &dampened_safety_check/1)
      |> Enum.count()

  defp safety_check(level) do
    increasing = Enum.uniq(level) |> Enum.sort()
    decreasing = Enum.reverse(increasing)

    if level in [increasing, decreasing] do
      gradual_check(level)
    else
      false
    end
  end

  defp dampened_safety_check(level) do
    if safety_check(level) do
      true
    else
      options =
        for i <- 0..(length(level) - 1),
            do: List.delete_at(level, i)

      Enum.any?(options, fn level -> safety_check(level) end)
    end
  end

  defp gradual_check(level),
    do:
      Enum.chunk_every(level, 2, 1, :discard)
      |> Enum.all?(fn [x, y] -> abs(x - y) <= 3 end)

  defp to_levels(line),
    do: String.split(line, " ") |> Enum.map(&String.to_integer/1)

  defp input_levels(),
    do:
      read_input("../inputs/d2.txt")
      |> Stream.map(&to_levels/1)
end
