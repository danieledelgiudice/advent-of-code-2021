defmodule AdventOfCode.Day06 do
  defp parse(input) do
    input
    |> String.split(["\r", "\n", ","], trim: true)
    |> Enum.map(&String.to_integer/1)
    |> Enum.frequencies()
  end

  defp step(pop) do
    pop
    |> Enum.map(fn
      {0, count} -> %{6 => count, 8 => count}
      {timer, count} -> %{(timer - 1) => count}
    end)
    |> Enum.reduce(fn map1, map2 ->
      Map.merge(map1, map2, fn _k, c1, c2 -> c1 + c2 end)
    end)
  end

  def part1(input) do
    input = parse(input)

    Enum.reduce(1..80, input, fn _, pop -> step(pop) end)
    |> Map.values()
    |> Enum.sum()
  end

  def part2(input) do
    input = parse(input)

    Enum.reduce(1..256, input, fn _, pop -> step(pop) end)
    |> Map.values()
    |> Enum.sum()
  end
end
