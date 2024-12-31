defmodule Aoc.D12 do
  import Aoc.Helpers

  @doc ~S"""
    Calculates the sum of the area multiplied by perimeter for all regions

    iex> Aoc.D12.p1()
    1930
  """
  def p1(input \\ "../inputs/sample12.txt") do
    grid =
      read_input(input) |> Enum.map(&String.graphemes/1)

    grid =
      for {row, row_index} <- Enum.with_index(grid),
          {element, col_index} <- Enum.with_index(row),
          do: {row_index, col_index, element}

    {_visited, regions} = to_regions(grid)

    Enum.reduce(regions, 0, fn {_type, area, perimeter}, acc ->
      acc + area * perimeter
    end)
  end

  defp to_regions(grid) do
    visited = MapSet.new()
    regions = []

    Enum.reduce(grid, {visited, regions}, fn {row, col, type}, {visited, regions} ->
      if not MapSet.member?(visited, {row, col}) do
        IO.inspect({row, col})

        {region_area, region_perimeter, new_visited} =
          scan_region({row, col}, type, grid, visited)

        {new_visited, [{type, region_area, region_perimeter} | regions]}
      else
        {visited, regions}
      end
    end)
  end

  defp scan_region(start, type, grid, visited) do
    starting_area = 0
    starting_perimeter = 0
    dfs([start], type, grid, visited, starting_area, starting_perimeter)
  end

  defp dfs([], _type, _grid, visited, area, perimeter), do: {area, perimeter, visited}

  defp dfs([current | rest], type, grid, visited, area, perimeter) do
    {row, col} = current

    # already visited
    if MapSet.member?(visited, current) do
      dfs(rest, type, grid, visited, area, perimeter)
    else
      visited = MapSet.put(visited, current) |> IO.inspect(label: "VISITED")

      # find neighbors
      neighbors = neighbors({row, col}, type, grid) |> IO.inspect(label: "NEIGHBORS")

      {new_neighbors, shared_edges} =
        Enum.split_with(neighbors, fn neighbor -> not MapSet.member?(visited, neighbor) end)

      IO.inspect(new_neighbors, label: "NEW NEIGHBOURS")

      IO.inspect(shared_edges, label: "SHARED EDGES")

      # area and perimeter
      area = area + 1
      perimeter = perimeter + 4 - length(shared_edges) * 2

      dfs(new_neighbors ++ rest, type, grid, visited, area, perimeter)
    end
  end

  defp neighbors({row, col}, type, grid) do
    Enum.filter(grid, fn {r, c, t} ->
      abs(row - r) + abs(col - c) == 1 and t == type
    end)
    |> Enum.map(fn {r, c, _t} -> {r, c} end)
  end
end
