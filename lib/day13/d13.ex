defmodule Aoc.D13 do
  import Aoc.Helpers
  require IEx

  @claw_pattern ~r/Button A: X\+(?<AX>\d+), Y\+(?<AY>\d+)\nButton B: X\+(?<BX>\d+), Y\+(?<BY>\d+)\nPrize: X\=(?<X>\d+), Y\=(?<Y>\d+)/

  @doc ~S"""
    Calculates the fewest tokens you would have to spend to win all possible prizes

    iex> Aoc.D13.p1()
    480
  """
  def p1(input \\ "../inputs/d13.txt") do
    read_input(input, "\n\n")
    |> Enum.map(&to_claw_tuple/1)
    |> Enum.map(&valid_games/1)
    |> List.flatten()
    |> Enum.sum()

  end

  def valid_games({ax, ay, bx, by, x, y}) do
    possibilities =
      for i <- 1..100,
        j <- 1..100,
        ax * i + bx * j == x,
        k <- 1..100,
        l <- 1..100,
        ay * k + by * l == y,
        i == k,
        j == l,
        do: 3 * i + j

      if Enum.count(possibilities) > 1 do
        cheapest(possibilities)
      else
        possibilities
      end
  end

  def cheapest(posibilities) do
    posibilities
    |> IO.inspect(label: "FINDING SMALLEST")
    |> Enum.min_by(fn cost -> cost end)
  end

  defp to_claw_tuple(line) do
    Regex.scan(@claw_pattern, line, capture: :all_names)
    |> List.flatten()
    |> parse_integers()
    |> List.to_tuple()
  end
end
