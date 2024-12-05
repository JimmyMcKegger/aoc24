defmodule Aoc.Day02 do
  @moduledoc """
  Day 02 Solutions.
  """

  alias Aoc.Helpers

  # TODO
  def p2 do

  end

  def p1 do
    Helpers.read_input("../inputs/d2input.txt")
    |> Enum.map(&to_levels/1)
    |> IO.inspect()
    |> Enum.filter(&safety_check/1)
    |> Enum.count()
  end

  defp safety_check(level) do
    increasing = Enum.uniq(level) |> Enum.sort
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

  defp gradual_check(level, :asc) do
    IO.inspect(level, label: "ascending")

    level
    |> Enum.chunk_every(2, 1, :discard)
    |> IO.inspect(label: "Sliding pairs")
    |> Enum.all?(fn [x, y] -> abs(x - y) <= 3 end)
    |> IO.inspect
  end

  defp gradual_check(level, :desc) do
    IO.inspect(level, label: "descending")

    level
    |> Enum.chunk_every(2, 1, :discard)
    |> IO.inspect(label: "Sliding pairs")
    |> Enum.all?(fn [x, y] -> abs(x - y) <= 3 end)
    |> IO.inspect
  end

  defp to_levels(line),
    do: String.split(line, " ") |> Enum.map(&String.to_integer/1)
end
