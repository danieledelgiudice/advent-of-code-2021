defmodule AdventOfCode.Day13 do
  defp parse(input) do
    [dots_rows, folds_rows] = String.split(input, ["\n\n", "\r\n\r\n"], trim: true)

    dots =
      for row <- String.split(dots_rows, ["\n", "\r\n"], trim: true),
          into: %MapSet{} do
        [x, y] = String.split(row, ",", trim: true)
        {String.to_integer(x), String.to_integer(y)}
      end

    folds =
      for row <- String.split(folds_rows, ["\n", "\r\n"], trim: true) do
        [axis, pos] = String.split(row, ["fold along ", "="], trim: true)
        {String.to_atom(axis), String.to_integer(pos)}
      end

    {dots, folds}
  end

  defp is_folding({x, _}, :x, pos), do: x > pos
  defp is_folding({_, y}, :y, pos), do: y > pos

  defp fold({x, y}, :x, pos), do: {2 * pos - x, y}
  defp fold({x, y}, :y, pos), do: {x, 2 * pos - y}

  defp do_fold({axis, pos}, dots) do
    {folding, fixed} = Enum.split_with(dots, &is_folding(&1, axis, pos))

    folding
    |> MapSet.new(&fold(&1, axis, pos))
    |> MapSet.union(MapSet.new(fixed))
  end

  defp do_folds(dots, folds) do
    Enum.reduce(folds, dots, &do_fold/2)
  end

  defp print(dots) do
    {width, _} = Enum.max_by(dots, fn {x, _} -> x end)
    {_, height} = Enum.max_by(dots, fn {_, y} -> y end)

    for y <- 0..height do
      for x <- 0..width do
        IO.write(
          if MapSet.member?(dots, {x, y}) do
            "#"
          else
            "."
          end
        )
      end

      IO.puts("")
    end

    IO.puts("")

    dots
  end

  def part1(input) do
    {dots, folds} = parse(input)

    [first_fold | _] = folds

    do_folds(dots, [first_fold])
    |> Enum.count()
  end

  def part2(input) do
    {dots, folds} = parse(input)

    do_folds(dots, folds)
    |> print()
  end
end
