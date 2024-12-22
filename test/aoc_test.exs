defmodule AocTest do
  use ExUnit.Case

  doctest Aoc.D4
  doctest Aoc.D7

  test "Day 1 part 1" do
    assert Aoc.Day01.solve_part1("../inputs/d1sample.txt") == 11
  end

  test "Day 1 part 2" do
    assert Aoc.Day01.solve_part2("../inputs/d1sample.txt") == 31
  end

  test "Day 11 part 1" do
    assert Aoc.D11.p1(
             6,
             "../inputs/d11sample.txt"
           ) == 22
  end

end
