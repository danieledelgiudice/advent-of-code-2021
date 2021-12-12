defmodule AdventOfCode.Day07 do
  defp parse(input) do
    input
    |> String.split([",", "\n"], trim: true)
    |> Enum.map(&String.to_integer/1)
  end

  defp median(list) do
    sorted = Enum.sort(list)
    mid = div(length(sorted), 2)
    Enum.at(sorted, mid)
  end

  defp fuel_usage_p1(list, pos) do
    Enum.map(list, &abs(&1 - pos))
    |> Enum.sum()
  end

  def part1(input) do
    input = parse(input)
    pos = median(input)
    fuel_usage_p1(input, pos)
  end

  defp check(list, pos) do
    a = fuel_usage_p2(list, pos - 1)
    b = fuel_usage_p2(list, pos)
    c = fuel_usage_p2(list, pos + 1)

    cond do
      a >= b and b <= c -> :done
      a >= b and b >= c -> :right
      a <= b and b <= c -> :left
    end
  end

  defp loop(list, a, b) do
    pos = div(a + b, 2)

    case check(list, pos) do
      :done -> pos
      :right -> loop(list, pos, b)
      :left -> loop(list, a, pos)
    end
  end

  defp fuel_usage_p2(list, pos) do
    Enum.map(list, &abs(&1 - pos))
    |> Enum.map(&div(&1 * (&1 + 1), 2))
    |> Enum.sum()
  end

  def part2(input) do
    list =
      input
      |> parse()
      |> Enum.sort()

    min = List.first(list)
    max = List.last(list)
    pos = loop(list, min, max)

    fuel_usage_p2(list, pos)
  end
end
