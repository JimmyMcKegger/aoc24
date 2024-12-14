defmodule Aoc.D11 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]
  require Integer

  @stone_rules %{
    0 => 1,
    1 => 2024,
    10 => [1, 0],
    99 => [9, 9],
    999 => 2021976
  }

  def p1 do
    blinks = 25

    read_input("../inputs/d11.txt")
    |> hd()
    |> String.split(" ")
    |> parse_integers()
    |> IO.inspect()
    |> blink(blinks, @stone_rules)
    |> Enum.count()

  end

  def blink(stones, 0, _cache), do: stones

  def blink(stones, count, cache) do

    Enum.map(stones, fn num ->
      new_stone = cache[num]

      cond do
        new_stone ->
          new_stone
        true ->
          # calculate and update cache
          new_stones = handle_new_number(num)
          cache = Map.put(cache, num, new_stones)
          new_stones
      end

    end)
    |> List.flatten()
    |> blink(count - 1, cache)
  end

  def handle_new_number(num) do
    digit_count = num |> Integer.digits() |> length

    calculate_new_stones(num, digit_count)
  end

  def calculate_new_stones(num, digit_count) when Integer.is_even(digit_count) do

      num
      |> Integer.to_charlist()
      |> Enum.chunk_every(div(digit_count, 2))
      |> Enum.map(fn chars ->
        to_string(chars)
        |> String.to_integer()
      end)
  end

  def calculate_new_stones(num, _digit_count) do
      num * 2024
  end

  def p2, do: 0
end
