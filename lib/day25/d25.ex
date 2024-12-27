defmodule Aoc.D25 do
  def p1(input \\ "sample.txt") do
    {keys, locks} =
      Path.join(__DIR__, input)
      |> read_inputs()
      |> Enum.map(&to_lock_or_key/1)
      |> Enum.split_with(fn {l, _n} -> l == :key end)

    every_combo =
      for k <- keys, l <- locks, do: {no_overlaps?(k, l), k, l}

		Enum.count(every_combo, fn {answer, _key_tup, _lock_tup} -> answer end)
  end

	defp no_overlaps?({:key, key_values}, {:lock, lock_values}) do
		[key_values, lock_values]
			|> Enum.map(&Tuple.to_list/1)
			|> Enum.zip()
			|> Enum.map(fn {a, b} -> a + b end)
			|> Enum.all?(&(&1 <= 5))
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
      tally_up(tail, :lock)
    else
			key_data = Enum.take([ head | tail], 6)
      tally_up(key_data, :key)
    end
  end

  defp tally_up(list, label) do
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
    |> labeler(label)
  end

  defp positional_adder({a1, b1, c1, d1, e1}, {a2, b2, c2, d2, e2}) do
    {a1 + a2, b1 + b2, c1 + c2, d1 + d2, e1 + e2}
  end

  defp labeler(tup, label), do: {label, tup}
end
