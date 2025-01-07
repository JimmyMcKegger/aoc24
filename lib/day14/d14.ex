defmodule Aoc.D14 do
  def p1(input \\ "sample.txt") do
    make_table()

    robo_info =
      read_input(input)
      |> Enum.map(&parse_robots/1)
      |> Enum.with_index()
      |> Enum.map(&into_robo_grid/1)

    IO.inspect(length(robo_info), label: "length")

    IO.inspect(cache_size(), label: "cache_size")

    # cleanup_table()

    robo_info
  end

  defp into_robo_grid({%{x: x, y: y, dx: dx, dy: dy}, index}) do
    position = {x, y}
    direction = {dx, dy}

    true = :ets.insert_new(:robo_grid, [{"R-#{index}", position}])

    %{robot: "R-#{index}", position: position, direction: direction}
  end

  defp parse_robots(line) do
    Regex.named_captures(~r/p=(?<x>-?\d+),(?<y>-?\d+) v=(?<dx>-?\d+),(?<dy>-?\d+)/, line)
    |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end

  defp read_input(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.split("\n", trim: true)
  end

  def get_robot(num) do
    :ets.lookup(:robo_grid, "R-#{num}")
  end

  def set_robot(num, position) do
    :ets.insert(:robo_grid, [{"R-#{num}", position}])
  end

  def make_table() do
    :ets.new(:robo_grid, [:set, :public, :named_table])
  end

  defp cleanup_table(), do: :ets.delete(:robo_grid)

  defp cache_size(),
    do: :ets.info(:robo_grid) |> Keyword.get(:size)
end
