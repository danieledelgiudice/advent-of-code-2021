defmodule AdventOfCode.Day10 do
  defp parse(input) do
    input
    |> String.split(["\r", "\n"], trim: true)
    |> Enum.map(&String.to_charlist/1)
  end

  defp scan(sequence, stack \\ [])
  defp scan([], []), do: :ok
  defp scan([], stack), do: {:incomplete, stack}

  # Opening new group
  defp scan([?( | rest], stack), do: scan(rest, [?( | stack])
  defp scan([?[ | rest], stack), do: scan(rest, [?[ | stack])
  defp scan([?{ | rest], stack), do: scan(rest, [?{ | stack])
  defp scan([?< | rest], stack), do: scan(rest, [?< | stack])

  # Closing last-opened group
  defp scan([?) | rest], [?( | stack_rest]), do: scan(rest, stack_rest)
  defp scan([?] | rest], [?[ | stack_rest]), do: scan(rest, stack_rest)
  defp scan([?} | rest], [?{ | stack_rest]), do: scan(rest, stack_rest)
  defp scan([?> | rest], [?< | stack_rest]), do: scan(rest, stack_rest)

  # Closing wrong group
  defp scan([c | _], _), do: {:corrupted, c}

  def part1(input) do
    input
    |> parse()
    |> Enum.map(&scan/1)
    |> Enum.map(fn
      {:corrupted, ?)} -> 3
      {:corrupted, ?]} -> 57
      {:corrupted, ?}} -> 1197
      {:corrupted, ?>} -> 25137
      _ -> 0
    end)
    |> Enum.sum()
  end

  def part2(input) do
    input
    |> parse()
    |> Enum.map(&scan/1)
    |> Enum.filter(fn
      {:incomplete, _} -> true
      _ -> false
    end)
    |> Enum.map(fn {_, stack} ->
      stack
      |> Enum.reduce(0, fn c, acc ->
        score =
          case c do
            ?( -> 1
            ?[ -> 2
            ?{ -> 3
            ?< -> 4
          end

        acc * 5 + score
      end)
    end)
    |> Enum.sort()
    |> then(&Enum.at(&1, div(Enum.count(&1), 2)))
  end
end
