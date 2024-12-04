defmodule Aoc.Day01 do
  @moduledoc """
  Day 01 Solutions.
  """

  alias Aoc.Helpers

  @spec solve_part1() :: number()
  def solve_part1,
    do:
      "../inputs/d1p1.txt"
      |> Helpers.read_input()
      |> Enum.reduce(%{first: [], second: []}, &map_of_lists(&1, &2))
      |> to_sorted()
      |> to_sum_of_ranges()

  @spec solve_part2() :: number()
  def solve_part2,
    do:
      "../inputs/d1p1.txt"
      |> Helpers.read_input()
      |> Enum.reduce(%{first: [], second: []}, &map_of_lists(&1, &2))
      |> find_similarities()
      |> Enum.sum()

  defp find_similarities(%{first: first, second: second}) do
    for num <- first, do: num * Enum.count(second, fn x -> num == x end)
  end

  defp to_sum_of_ranges([a, b]),
    do: Enum.zip(a, b) |> Enum.reduce(0, &add_ranges(&1, &2))

  defp add_ranges({first, second}, acc), do: acc + abs(second - first)

  defp map_of_lists(str, acc) do
    [a, b] = String.split(str, " ", trim: true)

    %{
      acc
      | first: [String.to_integer(a) | acc.first],
        second: [String.to_integer(b) | acc.second]
    }
  end

  defp to_sorted(%{first: first, second: second}), do: [Enum.sort(first), Enum.sort(second)]
end
