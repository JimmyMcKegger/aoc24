defmodule Aoc.D9 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]

  def p1(input \\ "../inputs/d9sample.txt") do
    read_input(input)
    |> hd()
    |> String.split("", trim: true)
    |> parse_integers()
    |> to_disk()
  end

  defp to_disk(list) do
    list
    |> Enum.chunk_every(2)
    |> Enum.with_index(fn chunk, i -> to_filespace({Integer.to_string(i), chunk}) end)
    |> Enum.join("")
  end

  defp to_filespace({i, [file]}), do: to_filespace({i, [file, 0]})

  defp to_filespace({i, [file_size, empty]}) do
    "#{String.duplicate(i, file_size)}#{String.duplicate(".", empty)}"
  end
end
