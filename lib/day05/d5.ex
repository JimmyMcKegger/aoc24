defmodule Aoc.PrintQueue do
  @moduledoc """
  Advent of Code Day 5
  """
  require IEx
  import Aoc.Helpers

  @doc ~S"""
  solves part 1

    iex> Aoc.PrintQueue.p1()
    143

  """
  def p1(path \\ "../inputs/d5sample.txt") do

    [ordering_rules, updates] = handle_inputs(path)

    Enum.reduce(updates, 0, fn line, acc->
      obeys_rules = for {x, y} <- ordering_rules, do: check_rule(line, x, y)

      if Enum.all?(obeys_rules) do
        middle = div(length(line), 2)
        acc + Enum.at(line, middle)
      else
        acc
      end
    end)
  end

  def p2(path \\ "../inputs/d5sample.txt") do
    [ordering_rules, updates] = handle_inputs(path)

    Enum.reduce(updates, 0, fn line, acc->

      obeys_rules = for {x, y} <- ordering_rules, do: check_rule(line, x, y)

      if Enum.any?(obeys_rules, &(&1 == false)) do

        sorted = enforce_rule(line, obeys_rules)

        middle = div(length(sorted), 2)
        acc + Enum.at(sorted, middle)
      else
        acc
      end
    end)
  end

  def enforce_rule(line, ordering_rules) do
    IO.inspect(line, label: "UNSORTED")

    sorted_line =
      Enum.sort(line, fn l, r ->
        cond do
          # Rule explicitly specifies l should come before r
          {l, r} in ordering_rules -> true
          # Rule explicitly specifies r should come before l
          {r, l} in ordering_rules -> false
          true -> true
        end
      end)

    IO.inspect(sorted_line, label: "SORTED")

    # Validate the global ordering
    all_rules_obeyed? =
      for {l, r} <- all_pairs(sorted_line), reduce: true do
        acc ->
          acc and
            (
              # If a rule exists, it must be respected
              {l, r} in ordering_rules or
                # Fallback for unordered elements
                (not {r, l} in ordering_rules and l <= r)
            )
      end

    if all_rules_obeyed? do
      sorted_line
    else
      IO.puts("Global order violated: #{inspect(sorted_line, charlists: :as_lists)}")
      :error
    end
  end

  defp all_pairs(list) do
    for i <- 0..(length(list) - 2), j <- (i + 1)..(length(list) - 1), do: {Enum.at(list, i), Enum.at(list, j)}
  end




  def check_rule(line, x, y) do

    first = Enum.find_index(line, &(&1 == x))
    IO.inspect(first, label: "FIRST", charlists: :as_lists)

    second = Enum.find_index(line, &(&1 == y))
    IO.inspect(second, label: "SECOND", charlists: :as_lists)

    case {first, second} do
      {nil, _y} -> true |> IO.inspect()
      {_x, nil} -> true |> IO.inspect()
      {x, y} -> (x < y) |> IO.inspect()
    end
  end

  defp handle_inputs(path) do
    [rules, pages] = read_inputs(path)
      |> String.split("\n\n")
      |> Enum.map(&(String.split(&1, "\n", trim: true)))

    ordering_rules = Enum.map(rules, fn str ->
        String.split(str, "|")
        |> Enum.map(&(String.to_integer(&1)))
        |> List.to_tuple()
      end)

    updates = Enum.map(pages, &(String.split(&1, ",")) |> parse_integers())

    [ordering_rules, updates]
  end
end
