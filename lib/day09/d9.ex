defmodule Aoc.D9 do
  import Aoc.Helpers, only: [read_input: 1, parse_integers: 1]

  def start_cache() do
    :ets.new(:disk_drive, [:set, :public, :named_table])
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
    |> IO.inspect()
    |> handle_list()

    fill_gaps()

  end

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

          IO.inspect("MOVING #{swap_value} from index #{index_to_move} to #{position}")
          {:cont, acc + (position * swap_value)}
        end

      [{^position, value}] ->
        # Already compacted
        {:cont, acc + (position * value)}

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
    for new_space <- cache_size()..((cache_size() + files) - 1),
        do: :ets.insert(:disk_drive, {new_space, file_id})

    %{data: false, file_id: file_id + 1}
  end

  def disk_map(0, %{data: false, file_id: file_id}) do
    %{data: true, file_id: file_id}
  end

  def disk_map(files, %{data: false, file_id: file_id}) do
    for new_space <- cache_size()..((cache_size() + files) - 1),
        do: :ets.insert(:disk_drive, {new_space, nil})

    %{data: true, file_id: file_id}
  end
end
