defmodule Aoc.D14 do
  import Aoc.Helpers, only: [read_input: 1]

  @input "../inputs/d14.txt"
  @robot_pattern ~r/p=(?<x>-?\d+),(?<y>-?\d+) v=(?<dx>-?\d+),(?<dy>-?\d+)/
  @grid_width 101
  @grid_height 103

  def p1(input \\ @input) do
    robot_info =
      read_input(input)
      |> Enum.map(&parse_robots/1)
      |> Enum.with_index()
      |> Enum.map(&into_map/1)

    seconds = for s <- 1..100, do: s

    Enum.reduce(seconds, robot_info, &teleport/2)
    |> Enum.reduce(%{q1: 0, q2: 0, q3: 0, q4: 0}, &to_quad/2)
    |> Map.values()
    |> Enum.product()
  end

  defp to_quad(robot, acc) do
    case find_quad(robot.position) do
      :q1 ->
        %{acc | q1: acc.q1 + 1}

      :q2 ->
        %{acc | q2: acc.q2 + 1}

      :q3 ->
        %{acc | q3: acc.q3 + 1}

      :q4 ->
        %{acc | q4: acc.q4 + 1}

      _ ->
        acc
    end
  end

  defp find_quad({x, _y}) when x == div(@grid_width, 2), do: nil
  defp find_quad({_x, y}) when y == div(@grid_height, 2), do: nil

  defp find_quad({x, y}) do
    mid_x = div(@grid_width, 2)
    mid_y = div(@grid_height, 2)

    cond do
      x < mid_x and y < mid_y ->
        :q1

      x > mid_x and y < mid_y ->
        :q2

      x < mid_x and y > mid_y ->
        :q3

      true ->
        :q4
    end
  end

  defp teleport(_second, robot_info) do
    Enum.map(robot_info, fn robot_map ->
      %{robot_map | position: jump(robot_map.position, robot_map.direction)}
    end)
  end

  defp jump({current_x, current_y}, {dx, dy}) do
    new_x = rem(current_x + dx, @grid_width)
    new_y = rem(current_y + dy, @grid_height)

    new_x = if new_x < 0, do: new_x + @grid_width, else: new_x
    new_y = if new_y < 0, do: new_y + @grid_height, else: new_y

    {new_x, new_y}
  end

  defp into_map({%{x: x, y: y, dx: dx, dy: dy}, index}) do
    position = {x, y}
    direction = {dx, dy}

    %{robot: "R-#{index}", position: position, direction: direction}
  end

  defp parse_robots(line) do
    Regex.named_captures(@robot_pattern, line)
    |> Map.new(fn {k, v} -> {String.to_atom(k), String.to_integer(v)} end)
  end
end
