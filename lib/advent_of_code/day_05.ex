defmodule AdventOfCode.Day05 do
  defp parse(input) do
    input
    |> String.split(["\n", "\r", " -> "], trim: true)
    |> Enum.map(fn coord ->
      [x, y] = String.split(coord, ",")
      {String.to_integer(x), String.to_integer(y)}
    end)
    |> Enum.chunk_every(2)
    |> Enum.map(&List.to_tuple/1)
  end

  def part1(input) do
    input
    |> parse()
    # Straight lines
    |> Enum.filter(fn {{x1, y1}, {x2, y2}} -> x1 == x2 or y1 == y2 end)
    |> Enum.flat_map(fn
      {{x, y1}, {x, y2}} -> Enum.map(y1..y2, &{x, &1})
      {{x1, y}, {x2, y}} -> Enum.map(x1..x2, &{&1, y})
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.flat_map(fn
      {{x, y1}, {x, y2}} -> Enum.map(y1..y2, &{x, &1})
      {{x1, y}, {x2, y}} -> Enum.map(x1..x2, &{&1, y})
      {{x1, y1}, {x2, y2}} -> Enum.zip(x1..x2, y1..y2)
    end)
    |> Enum.frequencies()
    |> Map.values()
    |> Enum.count(&(&1 >= 2))
  end
end
