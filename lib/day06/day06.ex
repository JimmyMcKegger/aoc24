defmodule Location do
  defstruct x: 0, y: 0
end

# a single guard is patrolling this part of the lab.
# Maybe you can work out where the guard will go ahead of time so that The Historians can search safely?
# You start by making a map (your puzzle input) of the situation. For example:
#
# The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.
#
# Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:
# If there is something directly in front of you, turn right 90 degrees.
# Otherwise, take a step forward.
# Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

defmodule Aoc.Day06 do
  alias Aoc.Helpers

  def p1 do
    grid =
      Helpers.read_input("../inputs/d6.txt") |> to_grid() |> IO.inspect()

    # find the start position '^'
    starting_location = find_starting_location(grid)

    patrol(grid, starting_location) |> Enum.uniq() |> Enum.count()
  end

  # Start patrol
  def patrol(grid, start_location), do: patrol(grid, start_location, :N, [start_location])

  def patrol(grid, current_location, direction, visited) do
    %Location{x: x, y: y} = current_location

    IO.inspect(current_location, label: "AT: ")

    # IEx.pry()
    # Check if the current position is within bounds
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
