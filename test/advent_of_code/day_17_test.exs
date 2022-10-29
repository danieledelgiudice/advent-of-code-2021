defmodule AdventOfCode.Day17Test do
  use ExUnit.Case

  import AdventOfCode.Day17

  @input "target area: x=20..30, y=-10..-5"

  test "part1" do
    input = @input
    result = part1(input)

    assert result === 45
  end

  test "part2" do
    input = @input
    result = part2(input)

    assert result === 112
  end
end
