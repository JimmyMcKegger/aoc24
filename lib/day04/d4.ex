defmodule Aoc.D4 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]

  @doc ~S"""
  Find the number of times the word "XMAS" appears in the grid.

  ## Examples

    iex> Aoc.D4.p1()
    18
  """
  def p1(input \\ "../inputs/d4sample.txt") do

    directions = [
      {0, 1, :right},
      {0, -1, :left},
      {1, 0, :down},
      {-1, 0, :up},
      {1, 1, :down_right},
      {1, -1, :down_left},
      {-1, 1, :up_right},
      {-1, -1, :up_left},
    ]

    # look for "XMAS"
    read_input(input)
        |> to_grid()
        |> scan_for_xmas(directions)
        |> Enum.count()
  end

  def scan_for_xmas(grid, directions) do
    for {row, row_index} <- Enum.with_index(grid),
      {letter, col_index} <- Enum.with_index(row),
      letter == "X",
      direction <- directions,
      check_xmas(grid, row_index, col_index, direction),
      do: {row_index, col_index, direction}
  end

  defp check_xmas(grid, row, col, {dy, dx, direction}) do
    try do
      max_row = Arrays.size(grid)
      max_col = Arrays.size(grid[0])

      # rule out wraparounds
      Enum.all?(0..3, fn i ->
        new_row = row + (i * dy)
        new_col = col + (i * dx)

        new_row >= 0 and new_row < max_row and
        new_col >= 0 and new_col < max_col and
        (dx >= 0 or div(new_col, max_col) == div(col, max_col))
      end) and
      # check the word
      (for i <- 0..3, do: grid[row + (i * dy)][col + (i * dx)]) == ["X", "M", "A", "S"]
    rescue
      _ -> false
    end
  end

  defp to_grid(input),
    do:
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Arrays.new/1)
      |> Arrays.new()


  @doc ~S"""
  Find the number of times an X of "MAS" appears in the grid.

  ## Examples

    iex> Aoc.D4.p2()
    9
  """
  def p2(input \\ "../inputs/d4sample.txt") do

    read_input(input)
    |> to_grid()
    |> scan_for_x_of_mas()
    |> Enum.count()
  end

  def scan_for_x_of_mas(grid) do
    for {row, row_index} <- Enum.with_index(grid),
      {letter, col_index} <- Enum.with_index(row),
      letter == "A",
      has_complete_x?(grid, row_index, col_index),
      do: {row_index, col_index}
  end

  def has_complete_x?(grid, row, col) do
    try do
    max_row = Arrays.size(grid)
    max_col = Arrays.size(grid[0])

    # check position
    valid_pos? = Enum.all?([-1, 1], fn i ->
      new_row = row + i
      new_col_left = col - i
      new_col_right = col + i

      new_row >= 0 and new_row < max_row and
      new_col_left >= 0 and new_col_left < max_col and
      new_col_right >= 0 and new_col_right < max_col
    end)

    x_mas_found = (
      (
        # MAS
        (grid[row - 1][col - 1] == "M" and grid[row + 1][col + 1] == "S") or
        # SAM
        (grid[row - 1][col - 1] == "S" and grid[row + 1][col + 1] == "M")
      ) or
      (
        # MAS
        (grid[row - 1][col + 1] == "M" and grid[row + 1][col - 1] == "S") or
        # SAM
        (grid[row - 1][col + 1] == "S" and grid[row + 1][col - 1] == "M")
      )
    )

    valid_check = check_x_of_mas(grid, row, col)

    valid_pos? and x_mas_found and valid_check
    rescue
      _ -> false
    end
  end

  def check_x_of_mas(grid, row, col) do
    x_map = %{
      upper_left: grid[row - 1][col - 1],
      upper_right: grid[row - 1][col + 1],
      lower_left: grid[row + 1][col - 1],
      lower_right: grid[row + 1][col + 1]
    }
    |> Map.values()
    |> Enum.frequencies()

    x_map == %{"M" => 2, "S" => 2}
  end
end
defmodule Aoc.D4 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]

  @doc ~S"""
  Find the number of times the word "XMAS" appears in the grid.

  ## Examples

    iex> Aoc.D4.p1()
    18
  """
  def p1(input \\ "../inputs/d4sample.txt") do

    directions = [
      {0, 1, :right},
      {0, -1, :left},
      {1, 0, :down},
      {-1, 0, :up},
      {1, 1, :down_right},
      {1, -1, :down_left},
      {-1, 1, :up_right},
      {-1, -1, :up_left},
    ]

    # look for "XMAS"
    read_input(input)
        |> to_grid()
        |> scan_for_xmas(directions)
        |> Enum.count()
  end

  def scan_for_xmas(grid, directions) do
    for {row, row_index} <- Enum.with_index(grid),
      {letter, col_index} <- Enum.with_index(row),
      letter == "X",
      direction <- directions,
      check_xmas(grid, row_index, col_index, direction),
      do: {row_index, col_index, direction}
  end

  defp check_xmas(grid, row, col, {dy, dx, direction}) do
    try do
      max_row = Arrays.size(grid)
      max_col = Arrays.size(grid[0])

      # rule out wraparounds
      Enum.all?(0..3, fn i ->
        new_row = row + (i * dy)
        new_col = col + (i * dx)

        new_row >= 0 and new_row < max_row and
        new_col >= 0 and new_col < max_col and
        (dx >= 0 or div(new_col, max_col) == div(col, max_col))
      end) and
      # check the word
      (for i <- 0..3, do: grid[row + (i * dy)][col + (i * dx)]) == ["X", "M", "A", "S"]
    rescue
      _ -> false
    end
  end

  defp to_grid(input),
    do:
      input
      |> Enum.map(&String.graphemes/1)
      |> Enum.map(&Arrays.new/1)
      |> Arrays.new()


  @doc ~S"""
  Find the number of times an X of "MAS" appears in the grid.

  ## Examples

    iex> Aoc.D4.p2()
    9
  """
  def p2(input \\ "../inputs/d4sample.txt") do

    read_input(input)
    |> to_grid()
    |> scan_for_x_of_mas()
    |> Enum.count()
  end

  def scan_for_x_of_mas(grid) do
    for {row, row_index} <- Enum.with_index(grid),
      {letter, col_index} <- Enum.with_index(row),
      letter == "A",
      has_complete_x?(grid, row_index, col_index),
      do: {row_index, col_index}
  end

  def has_complete_x?(grid, row, col) do
    try do
    max_row = Arrays.size(grid)
    max_col = Arrays.size(grid[0])

    # check position
    valid_pos? = Enum.all?([-1, 1], fn i ->
      new_row = row + i
      new_col_left = col - i
      new_col_right = col + i

      new_row >= 0 and new_row < max_row and
      new_col_left >= 0 and new_col_left < max_col and
      new_col_right >= 0 and new_col_right < max_col
    end)

    x_mas_found = (
      (
        # MAS
        (grid[row - 1][col - 1] == "M" and grid[row + 1][col + 1] == "S") or
        # SAM
        (grid[row - 1][col - 1] == "S" and grid[row + 1][col + 1] == "M")
      ) or
      (
        # MAS
        (grid[row - 1][col + 1] == "M" and grid[row + 1][col - 1] == "S") or
        # SAM
        (grid[row - 1][col + 1] == "S" and grid[row + 1][col - 1] == "M")
      )
    )

    valid_check = check_x_of_mas(grid, row, col)

    valid_pos? and x_mas_found and valid_check
    rescue
      _ -> false
    end
  end

  def check_x_of_mas(grid, row, col) do
    x_map = %{
      upper_left: grid[row - 1][col - 1],
      upper_right: grid[row - 1][col + 1],
      lower_left: grid[row + 1][col - 1],
      lower_right: grid[row + 1][col + 1]
    }
    |> Map.values()
    |> Enum.frequencies()

    x_map == %{"M" => 2, "S" => 2}
  end
end