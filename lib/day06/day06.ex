defmodule Location do
  defstruct x: 0, y: 0
end

# a single guard is patrolling this part of the lab.
# Maybe you can work out where the guard will go ahead of time so that The Historians can search safely?
# You start by making a map (your puzzle input) of the situation. For example:
#
# ....#.....
# .........#
# ..........
# ..#.......
# .......#..
# ..........
# .#..^.....
# ........#.
# #.........
# ......#...
# The map shows the current position of the guard with ^ (to indicate the guard is currently facing up from the perspective of the map). Any obstructions - crates, desks, alchemical reactors, etc. - are shown as #.
#
# Lab guards in 1518 follow a very strict patrol protocol which involves repeatedly following these steps:
# If there is something directly in front of you, turn right 90 degrees.
# Otherwise, take a step forward.
# Following the above protocol, the guard moves up several times until she reaches an obstacle (in this case, a pile of failed suit prototypes):

defmodule Aoc.Day06 do
  alias Aoc.Helpers

  @directions %{
    :N => { -1, 0 }, # Up
    :E => { 0, 1 },  # Right
    :S => { 1, 0 },  # Down
    :W => { 0, -1 }  # Left
  }

  def p1 do
    grid =
      Helpers.read_input("../inputs/d6sample.txt")
      |> to_grid()
      |> IO.inspect()

    # find the start position '^'
    starting_location = find_starting_location(grid)
    direction = :N

    IO.inspect(starting_location, label: "STARTING LOCATION")

    locations_visited = [starting_location]

    IO.inspect(locations_visited, label: "LOCATIONS VISITED")

    # Start patrolling
    final_locations = patrol(grid, starting_location, direction, locations_visited)

    IO.inspect(final_locations, label: "FINAL LOCATIONS VISITED")
  end

  def to_grid(input),
    do:
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Arrays.new/1)
      |> Arrays.new()

  def find_starting_location(grid) do
    result =
      for {row, row_index} <- Enum.with_index(grid),
          {element, col_index} <- Enum.with_index(row),
          element == "^",
          do: {row_index, col_index}

    {x, y} = result |> hd()

    %Location{x: x, y: y}
  end

  def patrol(grid, %Location{x: x, y: y} = current_location, direction, visited) do
    # Check if the current position is within bounds
    if current_location.x < 0 or current_location.y < 0 or current_location.x >= Arrays.size(grid) or y >= Arrays.size(Arrays.get(grid, 0)) do
      visited
    else
      current_cell = Arrays.get(grid, {x, y})

      # Check for an obstacle
      if current_cell == "#" do
        # Turn right
        new_direction = turn90(direction)
        patrol(grid, current_location, new_direction, visited)
      else
        # Mark the current location as visited
        visited = [current_location | visited]

        # Move forward in the current direction
        {dx, dy} = Map.get(@directions, direction)
        new_location = %Location{x: x + dx, y: y + dy}

        # Continue patrolling
        patrol(grid, new_location, direction, visited)
      end
    end
  end

  defp turn90(:N), do: :E
  defp turn90(:E), do: :S
  defp turn90(:S), do: :W
  defp turn90(:W), do: :N

end
