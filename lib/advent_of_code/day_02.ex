defmodule AdventOfCode.Day02 do
  @type direction :: :up | :down | :forward

  defp parse(input) do
    input
    |> String.split(~r{\n}, trim: true)
    |> Enum.map(fn line ->
      [dirString, numString] = String.split(line)

      direction =
        case dirString do
          "up" -> :up
          "down" -> :down
          "forward" -> :forward
        end

      num = String.to_integer(numString)

      {direction, num}
    end)
  end

  def part1(input) do
    input
    |> parse()
    |> do_part1({0, 0})
  end

  def part2(input) do
    input
    |> parse()
    |> do_part2({0, 0, 0})
  end

  defp do_part1([], {x, y}), do: x * y

  defp do_part1([{direction, num} | rest], {x, y}) do
    case direction do
      :up -> do_part1(rest, {x, y - num})
      :down -> do_part1(rest, {x, y + num})
      :forward -> do_part1(rest, {x + num, y})
    end
  end

  defp do_part2([], {x, y, _}), do: x * y

  defp do_part2([{direction, num} | rest], {x, y, aim}) do
    case direction do
      :up -> do_part2(rest, {x, y, aim - num})
      :down -> do_part2(rest, {x, y, aim + num})
      :forward -> do_part2(rest, {x + num, y + num * aim, aim})
    end
  end
end
