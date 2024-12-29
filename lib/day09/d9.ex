defmodule Aoc.D9 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]

  def start_cache() do
    :ets.new(:disk_drive, [:ordered_set, :public, :named_table])
  end

  def cache_size(),
    do: :ets.info(:disk_drive) |> Keyword.get(:size)

  @doc ~S"""
  Finds the filesystem's checksum

  ## Examples

    iex> Aoc.D9.p1()
    1928
  """
  def p1(input \\ "../inputs/d9sample.txt") do
    case :ets.whereis(:disk_drive) do
      :undefined -> start_cache()
      _ -> true
    end

    read_input(input)
    |> hd()
    |> String.graphemes()
    |> parse_integers()
    |> handle_list()

    result = fill_gaps()

    :ets.delete(:disk_drive)

    result
  end

  @doc ~S"""
  Moves whole files instead of individual blocks then calculates the filesystem's checksum

  ## Examples

    iex> Aoc.D9.p2()
    2858
  """
  def p2(input \\ "../inputs/d9sample.txt") do
    case :ets.whereis(:disk_drive) do
      :undefined -> start_cache()
      _ -> true
    end

    %{data: false, file_id: num_files_plus_one} =
      read_input(input)
      |> hd()
      |> String.graphemes()
      |> parse_integers()
      |> handle_list()

    file_locations =
      map_file_ranges(num_files_plus_one - 1) |> List.flatten()

    move_files_into_gaps(file_locations)

    last_position = cache_size() - 1

    result =
      Enum.reduce(0..last_position, 0, fn position, acc ->
        case :ets.lookup(:disk_drive, position) do
          [{^position, nil}] ->
            acc

          [{^position, value}] ->
            acc + position * value

          _ ->
            acc
        end
      end)

    :ets.delete(:disk_drive)
    result
  end

  def move_files_into_gaps(file_locations) do
    for file <- file_locations, do: try_to_compact(file)
  end

  def try_to_compact({a, b, file_id}) do
    empty_spaces = map_gap_ranges()

    case Enum.find(empty_spaces, fn {x, y, _true} ->
           file_space = Range.new(a, b)
           empty_space = Range.new(x, y)
           fits = Range.size(file_space) <= Range.size(empty_space)
           valid = a > x

           fits and valid
         end) do
      {x, y, _true} ->
        # move file and update empty space
        backfill({{a, b}, {x, y}, file_id})

      _ ->
        nil
    end
  end

  def backfill({{a, b}, {x, _y}, file_id}) do
    size_to_fill = (Range.new(a, b) |> Range.size()) - 1
    for space <- Range.new(x, x + size_to_fill), do: :ets.insert(:disk_drive, {space, file_id})

    for location <- Range.new(a, b), do: :ets.insert(:disk_drive, {location, nil})
  end

  def map_file_ranges(num_files) do
    for file <- num_files..0,
        do:
          :ets.match(:disk_drive, {:"$1", file})
          |> List.flatten()
          |> Enum.sort()
          |> Enum.reduce([], &make_range_files(&1, &2, file))
          |> List.flatten()
  end

  def map_gap_ranges() do
    :ets.match(:disk_drive, {:"$1", nil})
    |> List.flatten()
    |> Enum.sort()
    |> Enum.reduce([], &make_range_gaps/2)
    |> Enum.reverse()
  end

  def make_range_files(num, [], file),
    do: [{num, num, file}]

  def make_range_files(num, [{start, last, file} | rest], file) when num == last + 1,
    do: [{start, num, file} | rest]

  def make_range_files(num, acc, file),
    do: [{num, num, file} | acc]

  def make_range_gaps(num, []),
    do: [{num, num, true}]

  def make_range_gaps(num, [{start, last, true} | rest]) when num == last + 1,
    do: [{start, num, true} | rest]

  def make_range_gaps(num, acc),
    do: [{num, num, true} | acc]

  def fill_gaps() do
    last_position = cache_size() - 1

    Enum.reduce_while(0..last_position, 0, fn position, acc ->
      handle_gaps(position, acc, last_position)
    end)
  end

  def handle_gaps(position, acc, last_position) do
    case :ets.lookup(:disk_drive, position) do
      [{^position, nil}] ->
        {index_to_move, swap_value} = get_last_data(last_position)

        if index_to_move <= position do
          # no more data to move
          {:halt, acc}
        else
          :ets.delete(:disk_drive, index_to_move)
          :ets.insert(:disk_drive, {position, swap_value})

          {:cont, acc + position * swap_value}
        end

      [{^position, value}] ->
        # Already compacted
        {:cont, acc + position * value}

      _ ->
        {:cont, acc}
    end
  end

  def get_last_data(last_position) do
    find_last_valid(last_position)
  end

  defp find_last_valid(pos) when pos < 0 do
    # no more data
    {:halt, nil}
  end

  defp find_last_valid(pos) do
    case :ets.lookup(:disk_drive, pos) do
      [{^pos, nil}] ->
        find_last_valid(pos - 1)

      [{^pos, value}] ->
        {pos, value}

      _ ->
        find_last_valid(pos - 1)
    end
  end

  def handle_list(list) do
    Enum.reduce(list, %{data: true, file_id: 0}, &disk_map(&1, &2))
  end

  def disk_map(files, %{data: true, file_id: file_id}) do
    for new_space <- cache_size()..(cache_size() + files - 1),
        do: :ets.insert(:disk_drive, {new_space, file_id})

    %{data: false, file_id: file_id + 1}
  end

  def disk_map(0, %{data: false, file_id: file_id}) do
    %{data: true, file_id: file_id}
  end

  def disk_map(files, %{data: false, file_id: file_id}) do
    for new_space <- cache_size()..(cache_size() + files - 1),
        do: :ets.insert(:disk_drive, {new_space, nil})

    %{data: true, file_id: file_id}
  end
end
