defmodule Aoc.D11 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]
  require Integer

  @input "../inputs/d11.txt"

  def start_cache() do
    :ets.new(:stone_cache, [:set, :public, :named_table])

    :ets.insert(:stone_cache, [
      {0, 1},
      {1, 2024},
      {10, [1, 0]},
      {99, [9, 9]},
      {999, 2_021_976}
    ])
  end

  def p1(blinks \\ 25, input \\ @input) do

    case :ets.whereis(:stone_cache) do
      :undefined -> start_cache()
      _ -> true
    end

    read_input(input)
    |> hd()
    |> String.split(" ")
    |> parse_integers()
    |> IO.inspect()
    |> blink(blinks)
    |> Enum.count()
  end

  def blink(stones, 0), do: List.flatten(stones)

  def blink(stones, count) do
    IO.inspect(count, label: "COUNT")

    new_stones =
      Enum.map(stones, &process_stone/1)
      |> List.flatten()

    blink(new_stones, count - 1)
  end

  def process_stone(num) do
    case :ets.lookup(:stone_cache, num) do
      [{^num, existing_result}] ->
        existing_result

      [] ->
        new_result = handle_new_number(num)
        :ets.insert(:stone_cache, {num, new_result})
        new_result
    end
  end

  def handle_new_number(num) do
    digit_count = :math.log10(num) |> trunc()

    calculate_new_stones(num, digit_count + 1)
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

  def p2, do: p1(75, @input)
end
