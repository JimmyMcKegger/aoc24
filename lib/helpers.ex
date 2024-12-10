defmodule Aoc.Helpers do
  @moduledoc """
  Common utilities for Advent of Code.
  """

  @base_url "https://adventofcode.com/2024"
  @session_cookie System.get_env("AOC_SESSION") ||
                    IO.puts("Missing AOC_SESSION environment variable")

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

  def fetch_problem(day) when is_integer(day) and day > 0 do
    url = "#{@base_url}/day/#{day}"

    headers = [
      {"Cookie", "session=#{@session_cookie}"}
    ]

    case HTTPoison.get(url, headers) do
      {:ok, %HTTPoison.Response{status_code: 200, body: body}} ->
        {:ok, parse_problem(body)}

      {:ok, %HTTPoison.Response{status_code: status_code}} ->
        {:error, "Failed to fetch problem, status code: #{status_code}"}

      {:error, %HTTPoison.Error{reason: reason}} ->
        {:error, "HTTP request failed: #{reason}"}
    end
  end

  # Parses the problem description from HTML
  defp parse_problem(html) do
    Floki.parse_document!(html)
    |> Floki.find(".day-desc")
    |> Floki.text()
  end
end
