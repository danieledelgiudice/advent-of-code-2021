defmodule AdventOfCode.Day18 do
  def part1(input) do
    input
    |> parse()
    |> sum()
    |> magnitude()
  end

  def part2(input) do
    list = parse(input)

    for x <- list, y <- list do
      sum([x, y]) |> magnitude
    end
    |> Enum.max()
  end

  defp parse(input) do
    input
    |> String.split("\n", trim: true)
    |> Enum.map(fn s -> String.split(s, "", trim: true) end)
  end

  defp explode(list, depth, cr, done) do
    case {done, depth, list} do
      {false, 4, ["[", a, ",", b, "]" | rest]} ->
        {rest, _} = explode(rest, depth, b, true)
        {["0" | rest], a}

      {_, _, ["," | rest]} ->
        {rest, cl} = explode(rest, depth, cr, done)
        {["," | rest], cl}

      {_, _, ["[" | rest]} ->
        {rest, cl} = explode(rest, depth + 1, cr, done)
        {["[" | rest], cl}

      {_, _, ["]" | rest]} ->
        {rest, cl} = explode(rest, depth - 1, cr, done)
        {["]" | rest], cl}

      {_, _, [n | rest]} ->
        {rest, cl} = explode(rest, depth, "0", done)
        v = Enum.map([n, cr, cl], &String.to_integer/1) |> Enum.sum()
        {["#{v}" | rest], "0"}

      {_, _, n} ->
        {n, "0"}
    end
  end

  defp explode(list) do
    elem(explode(list, 0, "0", false), 0)
  end

  defp split(list, done \\ false) do
    case list do
      [n | rest] ->
        if not done and String.length(n) > 1 do
          val = String.to_integer(n)
          x = div(val, 2)
          ["[", "#{x}", ",", "#{val - x}", "]" | split(rest, true)]
        else
          [n | split(rest, done)]
        end

      [] ->
        []
    end
  end

  defp reduce(s) do
    snext = explode(s)

    if snext != s do
      reduce(snext)
    else
      snext = split(s)

      if snext != s do
        reduce(snext)
      else
        s
      end
    end
  end

  defp sum(ns) do
    case ns do
      [a, b | rest] ->
        ns = List.flatten(["[", a, ",", b, "]"]) |> reduce
        sum([ns | rest])

      [n] ->
        n

      [] ->
        []
    end
  end

  defp do_magnitude(list) do
    case list do
      [a, b] -> 3 * do_magnitude(a) + 2 * do_magnitude(b)
      v -> v
    end
  end

  defp magnitude(s) do
    {:ok, list} = Enum.join(s) |> Code.string_to_quoted(s)
    do_magnitude(list)
  end
end
