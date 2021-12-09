defmodule AdventOfCode.Day04 do
  defp parse(input) do
    [rolls_line | boards_lines] = String.split(input, ["\r", "\n"], trim: true)

    rolls =
      rolls_line
      |> String.split(",")
      |> Enum.map(&String.to_integer/1)

    boards =
      boards_lines
      |> Enum.map(fn line ->
        String.split(line)
        |> Enum.map(&String.to_integer/1)
      end)
      |> Enum.chunk_every(5)

    {rolls, boards}
  end

  defp mark_roll(board, roll) do
    Enum.map(board, fn row ->
      Enum.map(row, &if(&1 == roll, do: :ok, else: &1))
    end)
  end

  defp is_board_won?(board) do
    board_rotated = List.zip(board) |> Enum.map(&Tuple.to_list/1)
    is_row_won?(board) or is_row_won?(board_rotated)
  end

  defp is_row_won?(board) do
    Enum.member?(board, [:ok, :ok, :ok, :ok, :ok])
  end

  defp play_to_win(boards, rolls) do
    Enum.reduce_while(rolls, boards, fn roll, boards ->
      boards = Enum.map(boards, &mark_roll(&1, roll))
      winner = Enum.find(boards, &is_board_won?/1)

      case winner do
        nil -> {:cont, boards}
        _ -> {:halt, {winner, roll}}
      end
    end)
  end

  def play_to_lose(boards, rolls) do
    Enum.reduce_while(rolls, boards, fn
      roll, boards ->
        boards = Enum.map(boards, &mark_roll(&1, roll))
        {won_boards, remaining_boards} = Enum.split_with(boards, &is_board_won?/1)

        case remaining_boards do
          [] ->
            [first_won | _] = won_boards
            {:halt, {first_won, roll}}

          _ ->
            {:cont, remaining_boards}
        end
    end)
  end

  defp score(board, last_roll) do
    sum_unmarked =
      List.flatten(board)
      |> Enum.map(&if &1 == :ok, do: 0, else: &1)
      |> Enum.sum()

    sum_unmarked * last_roll
  end

  def part1(input) do
    {rolls, boards} = parse(input)
    {winner, last_roll} = play_to_win(boards, rolls)
    score(winner, last_roll)
  end

  def part2(input) do
    {rolls, boards} = parse(input)
    {winner, last_roll} = play_to_lose(boards, rolls)
    score(winner, last_roll)
  end
end
