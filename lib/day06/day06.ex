defmodule Location do
  defstruct x: 0, y: 0
end

defmodule Aoc.Day06 do
  import Aoc.Helpers

  def p1 do
    grid =
      read_input("../inputs/d6.txt")
      |> to_grid()

    # find the start position '^'
    starting_location = find_starting_location(grid)

    patrol(grid, starting_location) |> Enum.uniq() |> Enum.count()
  end

  def p2 do
    grid =
      "../inputs/d6.txt"
      |> read_input()
      |> to_grid()

    grid
    |> find_empty_spaces()
    |> Stream.filter(fn {x, y} ->
      will_get_stuck_in_loop(grid, find_starting_location(grid), {x, y})
    end)
    |> Enum.to_list()
    |> length()
  end

  # Return true if the guard will get stuck in a loop
  defp will_get_stuck_in_loop(grid, starting_location, new_obstruction) do
    loop_patrol(grid, starting_location, new_obstruction)
  end

  defp loop_patrol(grid, starting_location, new_obstruction) do
    loop_patrol(grid, starting_location, :N, [], new_obstruction)
  end

  defp loop_patrol(
         grid,
         %Location{x: x, y: y} = current_location,
         direction,
         visited,
         new_obstruction
       ) do
    cond do
      # guard has already been to this location in this direction, they will get stuck in a loop
      {current_location, direction} in visited ->
        true

      # guard is out of bounds, they will not get stuck in a loop
      x < 0 or y < 0 or x >= Arrays.size(grid) or y >= Arrays.size(Arrays.get(grid, 0)) ->
        false

      # guard hits an obstacle, step back and turn right
      grid[x][y] == "#" or {x, y} == new_obstruction ->
        {last_location, _last_direction} = hd(visited)
        loop_patrol(grid, last_location, turn(direction), visited, new_obstruction)

      # guard moves forward in the current direction and adds the current location and direction to the visited list
      true ->
        {dx, dy} = take_step(direction)
        new_location = %Location{x: x + dx, y: y + dy}

        loop_patrol(
          grid,
          new_location,
          direction,
          [{current_location, direction} | visited],
          new_obstruction
        )
    end
  end

  # Start patrol
  defp patrol(grid, start_location), do: patrol(grid, start_location, :N, [start_location])

  defp patrol(grid, current_location, direction, visited) do
    %Location{x: x, y: y} = current_location

    if x < 0 or y < 0 or x >= Arrays.size(grid) or y >= Arrays.size(Arrays.get(grid, 0)) do
      visited
    else
      current_cell = grid[x][y]

      # Check for an obstacle
      if current_cell == "#" do
        # turn right from last step
        patrol(grid, hd(visited), turn(direction), visited)
      else
        # Move forward in the current direction
        {dx, dy} = take_step(direction)
        new_location = %Location{x: x + dx, y: y + dy}

        patrol(grid, new_location, direction, [current_location | visited])
      end
    end
  end

  defp find_empty_spaces(grid) do
    for {row, row_index} <- Enum.with_index(grid),
        {element, col_index} <- Enum.with_index(row),
        element == ".",
        do: {row_index, col_index}
  end

  defp turn(:N), do: :E
  defp turn(:E), do: :S
  defp turn(:S), do: :W
  defp turn(:W), do: :N

  defp take_step(dir) do
    case dir do
      :N ->
        {-1, 0}

      :E ->
        {0, 1}

      :S ->
        {1, 0}

      _ ->
        {0, -1}
    end
  end

  defp find_starting_location(grid) do
    result =
      for {row, row_index} <- Enum.with_index(grid),
          {element, col_index} <- Enum.with_index(row),
          element == "^",
          do: {row_index, col_index}

    {x, y} = result |> hd()

    %Location{x: x, y: y}
  end

  defp to_grid(input),
    do:
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Arrays.new/1)
      |> Arrays.new()
end
