defmodule Aoc.D7 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]


  @doc ~S"""
  Finds the sum of the test values from just the equations that could possibly be true.

    iex> Aoc.D7.p1()
    3749

  """
  def p1(input \\ "../inputs/d7sample.txt") do
    input
    |> read_input()
    |> Enum.map(&(String.split(&1, [":", " "], trim: true) |> parse_integers()))
    |> Enum.map(&to_equations(&1))
    |> Enum.map(&tabulate(&1))
    |> Enum.filter(fn {expected, candidates} ->
      Enum.member?(candidates, expected)
    end)
    |> Enum.reduce(0, fn {value, _}, acc ->
      acc + value
    end)
  end

  @doc ~S"""
  Finds the sum of the test values from just the equations that could possibly be true.

    iex> Aoc.D7.p2()
    11387

  """
  def p2(input \\ "../inputs/d7sample.txt") do
    input
    |> read_input()
    |> Enum.map(&(String.split(&1, [":", " "], trim: true) |> parse_integers()))
    |> Enum.map(&to_equations(&1))
    |> Enum.map(&re_tabulate/1)
    |> Enum.filter(fn {expected, candidates} ->
      Enum.member?(candidates, expected)
    end)
    |> Enum.reduce(0, fn {value, _}, acc ->
      acc + value
    end)
  end

  defp re_tabulate({potential_result, [], final_possibilities}) do
    {potential_result, final_possibilities}
  end
  defp re_tabulate({potential_result, [last_num], possibilities}) do

    all_possibilities =
      for possibility <- possibilities, do: [last_num + possibility] ++ [possibility * last_num] ++ [String.to_integer("#{possibility}#{last_num}")]

    re_tabulate({potential_result, [], List.flatten(all_possibilities)})
  end

  defp re_tabulate({potential_result, [head | tail], []}) do

    re_tabulate({potential_result, tail, [head]})
  end

  defp re_tabulate({potential_result, [head | tail], possibilities}) do

    all_possibilities =
      for possibility <- possibilities, do: [possibility + head] ++ [possibility * head] ++ [String.to_integer("#{possibility}#{head}")]

    re_tabulate({potential_result, tail, List.flatten(all_possibilities)})
  end

  defp tabulate({potential_result, [], possibilities}) do
    {potential_result, possibilities}
  end


  defp tabulate({potential_result, [last_num], possibilities}) do

    all_possibilities =
      for possibility <- possibilities, do: [last_num + possibility] ++ [possibility * last_num]

    tabulate({potential_result, [], List.flatten(all_possibilities)})
  end

  defp tabulate({potential_result, [head | tail], []}) do

    tabulate({potential_result, tail, [head]})
  end

  defp tabulate({potential_result, [head | tail], possibilities}) do

    all_possibilities =
      for possibility <- possibilities, do: [possibility + head] ++ [possibility * head]

    tabulate({potential_result, tail, List.flatten(all_possibilities)})
  end

  defp to_equations([potential_result | potential_values]),
    do: {potential_result, potential_values, []}
end
