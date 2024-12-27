defmodule Aoc.D25 do
  def p1(input \\ "sample.txt") do
    {keys, locks} =
      Path.join(__DIR__, input)
      |> read_inputs()
      |> Enum.map(&to_lock_or_key/1)
      |> Enum.split_with(fn {l, _n} -> l == :key end)

    every_combo =
      for k <- keys, l <- locks, do: [k, l]


  end

  defp read_inputs(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n\n", trim: true)
    |> Enum.map(&String.split(&1, "\n", trim: true))
  end

  defp to_lock_or_key([head | tail]) do
    if head == "#####" do
      make_key(tail)
    else
      make_lock(tail)
    end
  end

  defp make_key(list) do
    Enum.reduce(list, {0, 0, 0, 0, 0}, fn line, acc ->
      String.graphemes(line)
      |> Enum.map(
        &if &1 == "#" do
          1
        else
          0
        end
      )
      |> List.to_tuple()
      |> positional_adder(acc)
    end)
    |> labeler(:key)
  end

  defp make_lock(list) do
    Enum.reduce(list, {0, 0, 0, 0, 0}, fn line, acc ->
      String.graphemes(line)
      |> Enum.map(
        &if &1 == "#" do
          1
        else
          0
        end
      )
      |> List.to_tuple()
      |> positional_adder(acc)
    end)
    |> labeler(:lock)
  end

  defp positional_adder({a1, b1, c1, d1, e1}, {a2, b2, c2, d2, e2}) do
    {a1 + a2, b1 + b2, c1 + c2, d1 + d2, e1 + e2}
  end

  defp labeler(tup, label), do: {label, tup}
end
