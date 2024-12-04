defmodule Aoc.Helpers do
  @moduledoc """
  Common utilities for Advent of Code.
  """

  def read_input(file_path) do
    file_path
    |> Path.expand(__DIR__)
    |> File.read!()
    |> String.trim()
    |> String.split("\n", trim: true)
  end

  def parse_integers(lines) do
    Enum.map(lines, &String.to_integer/1)
  end
end
