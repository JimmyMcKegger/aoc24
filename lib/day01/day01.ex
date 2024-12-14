defmodule Aoc.Day01 do
  @moduledoc """
  Day 01 Solutions.
  """

  alias Aoc.Helpers

  @spec solve_part1() :: number()
  def solve_part1,
    do:
      input_map()
      |> to_sorted()
      |> to_sum_of_ranges()

  @spec solve_part2() :: number()
  def solve_part2,
    do:
      input_map()
      |> find_similarities()
      |> Enum.sum()

  defp input_map(),
    do:
      Helpers.read_input("../inputs/d1sample.txt")
      |> Enum.reduce(%{first: [], second: []}, &map_of_lists(&1, &2))

  defp map_of_lists(str, acc) do
    [a, b] = String.split(str, " ", trim: true)

    %{
      acc
      | first: [String.to_integer(a) | acc.first],
        second: [String.to_integer(b) | acc.second]
    }
  end

  defp to_sorted(%{first: first, second: second}), do: [Enum.sort(first), Enum.sort(second)]

  defp add_ranges({first, second}, acc), do: acc + abs(second - first)

  defp to_sum_of_ranges([a, b]),
    do: Enum.zip(a, b) |> Enum.reduce(0, &add_ranges(&1, &2))

  defp find_similarities(%{first: first, second: second}) do
    for num <- first, do: num * Enum.count(second, fn x -> num == x end)
  end
end
