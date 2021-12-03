defmodule AdventOfCode.Day01 do
  def part1(input) do
    input = parse(input)
    do_part1(input)
  end

  def part2(input) do
    input = parse(input)
    do_part2(input)
  end

  defp parse(input) do
    input
    |> String.split()
    |> Enum.map(&String.to_integer/1)
  end

  defp do_part1([_ | []]), do: 0

  defp do_part1([a, b | rest]) do
    count = if a < b, do: 1, else: 0
    count + do_part1([b | rest])
  end

  defp do_part2([_ | []]), do: 0
  defp do_part2([_a, _b | []]), do: 0
  defp do_part2([_a, _b, _c | []]), do: 0

  defp do_part2([a, b, c, d | rest]) do
    count = if a < d, do: 1, else: 0
    count + do_part2([b, c, d | rest])
  end
end
