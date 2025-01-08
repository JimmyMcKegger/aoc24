defmodule Aoc.D12 do
  import Aoc.Helpers
  require IEx

  @doc ~S"""
    Calculates the sum of the area multiplied by perimeter for all regions

    iex> Aoc.D12.p1()
    140
  """
  def p1(input \\ "../inputs/sample12.txt") do
    make_grid(input)
    |> to_regions()
    |> Enum.reduce(0, fn {_type, area, perimeter, _total_sides}, acc ->
      acc + area * perimeter
    end)
  end

  @doc ~S"""
    Calculates the sum of the area multiplied by total sides for all regions

    iex> Aoc.D12.p2()
    80
  """
  def p2(input \\ "../inputs/sample12.txt") do
    make_grid(input)
    |> to_regions()
    |> Enum.reduce(0, fn {_type, area, _perimeter, total_sides}, acc ->
      acc + area * total_sides
    end)
  end

  defp to_regions(grid) do
    {_visited, regions} =
      Enum.reduce(grid, {MapSet.new(), []}, fn {row, col, type}, {visited, regions} ->
        if not MapSet.member?(visited, {row, col}) do
          {region_area, region_perimeter, region_total_sides, new_visited} =
            scan_region({row, col}, type, grid, visited) |> IO.inspect(label: :region)

          {new_visited, [{type, region_area, region_perimeter, region_total_sides} | regions]}
        else
          {visited, regions}
        end
      end)

    regions
  end

  defp scan_region(start, type, grid, visited),
    do: dfs([start], type, grid, visited, 0, 0, 4, [])

  defp dfs([], _type, _grid, visited, area, perimeter, total_sides, all_region) do
      # calculate the region total
      IO.inspect(all_region)
      IEx.pry()
      # min 4, uniq rows * uniq cols,

      total_sides = min(4, 10)
     {area, perimeter, total_sides, visited}
  end

  defp dfs([current | rest], type, grid, visited, area, perimeter, total_sides, all_region) do
    {row, col} = current

    # already visited
    if MapSet.member?(visited, current) do
      dfs(rest, type, grid, visited, area, perimeter, total_sides, all_region)
    else
      visited = MapSet.put(visited, current) |> IO.inspect(label: "VISITED")

      # find neighbors
      neighbors = neighbors({row, col}, type, grid) |> IO.inspect(label: "NEIGHBORS")

      all_region = Enum.reduce(neighbors, all_region, fn n, acc ->
        [n | acc]
      end) |> Enum.uniq()

      {new_neighbors, shared_edges} =
        Enum.split_with(neighbors, fn neighbor -> not MapSet.member?(visited, neighbor) end)

      IO.inspect(new_neighbors, label: "NEW NEIGHBOURS")

      IO.inspect(shared_edges, label: "SHARED EDGES")

      IO.inspect(all_region, label: "ALL REGION")

      # area and perimeter
      area = area + 1 |> IO.inspect(label: :area)
      perimeter = perimeter + 4 - length(shared_edges) * 2 |> IO.inspect(label: :perimeter)

      dfs(new_neighbors ++ rest, type, grid, visited, area, perimeter, total_sides, all_region)
    end
  end

  defp neighbors({row, col}, type, grid) do
    Enum.filter(grid, fn {r, c, t} ->
      abs(row - r) + abs(col - c) == 1 and t == type
    end)
    |> Enum.map(fn {r, c, _t} -> {r, c} end)
  end

  defp make_grid(input) do
    grid = read_input(input) |> Enum.map(&String.graphemes/1)

    for {row, row_index} <- Enum.with_index(grid),
        {element, col_index} <- Enum.with_index(row),
        do: {row_index, col_index, element}
  end
end
