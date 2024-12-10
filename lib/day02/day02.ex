defmodule Aoc.Day02 do
  @moduledoc """
  Day 02 Solutions.
  """
  alias Aoc.Helpers

  def p1 do
    "../inputs/d2.txt"
    |> Helpers.read_input()
    |> Stream.map(&to_levels/1)
    |> Stream.filter(&safety_check/1)
    |> Enum.count()
  end

  def p2 do
    "../inputs/d2.txt"
    |> Helpers.read_input()
    |> Enum.map(&to_levels/1)
    |> Enum.filter(&dampened_safety_check/1)
    |> Enum.count()
  end

  defp safety_check(level) do
    increasing = Enum.uniq(level) |> Enum.sort()
    decreasing = Enum.reverse(increasing)

    cond do
      level == increasing ->
        gradual_check(level, :asc)

      level == decreasing ->
        gradual_check(level, :desc)

      true ->
        IO.puts("invalid")
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

      options
      |> Enum.any?(fn level -> safety_check(level) end)
    end
  end

  defp gradual_check(level, :asc) do
    level
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [x, y] -> abs(x - y) <= 3 end)
  end

  defp gradual_check(level, :desc) do
    level
    |> Enum.chunk_every(2, 1, :discard)
    |> Enum.all?(fn [x, y] -> abs(x - y) <= 3 end)
  end

  defp to_levels(line),
    do: String.split(line, " ") |> Enum.map(&String.to_integer/1)
end
