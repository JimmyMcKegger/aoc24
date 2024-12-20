defmodule Aoc.Day01 do
  @moduledoc """
  Day 01 Solutions.
  """

  alias Aoc.Helpers

  @doc ~S"""
  Takes the path to the input file and outputs the sum of distances

  ## Examples

      iex> Aoc.Day01.solve_part1("../inputs/d1sample.txt")
      iex> 11

  """
  def solve_part1(input \\ "../inputs/d1.txt"),
    do:
      input_map(input)
      |> to_sorted()
      |> to_sum_of_ranges()

  def solve_part2(input \\ "../inputs/d1.txt"),
    do:
      input_map(input)
      |> find_similarities()
      |> Enum.sum()

  defp input_map(input),
    do:
      Helpers.read_input(input)
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
