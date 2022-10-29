defmodule AdventOfCode.Day17 do
  def part1(input) do
    target = parse(input)
    {x_range, _} = target

    for x <- 1..(x_range.last + 1), y <- -500..500 do
      case simulate({x, y}, target) do
        nil -> 0
        height -> height
      end
    end
    |> Enum.max()
  end

  def part2(input) do
    target = parse(input)
    {x_range, _} = target

    for x <- 1..(x_range.last + 1), y <- -500..500 do
      case simulate({x, y}, target) do
        nil -> 0
        _ -> 1
      end
    end
    |> Enum.sum()
  end

  def parse(input) do
    [x1, x2, y1, y2] =
      ~r/x=([-\d]+)\.\.([-\d]+), y=([-\d]+)\.\.([-\d]+)/
      |> Regex.run(input, capture: :all_but_first)
      |> Enum.map(&String.to_integer/1)

    {x1..x2, y1..y2}
  end

  def step({{x, y}, max_y, {dx, dy}}) do
    next_y = y + dy
    {{x + dx, next_y}, max(max_y, next_y), {max(dx - 1, 0), dy - 1}}
  end

  defp missed?({x, y}, {x_range, y_range}) do
    x > x_range.last or y < y_range.first
  end

  defp still_going?({x, y} = pos, {xs, ys} = target) do
    (x not in xs or y not in ys) and not missed?(pos, target)
  end

  defp simulate(speed, target) do
    # { position, max_height, speed}
    initial = {{0, 0}, 0, speed}

    {final_position, max_height, _} =
      Stream.iterate(initial, &step/1)
      |> Stream.drop_while(fn {pos, _, _} ->
        still_going?(pos, target)
      end)
      |> Enum.take(1)
      |> hd()

    case(missed?(final_position, target)) do
      true -> nil
      false -> max_height
    end
  end
end
