#!/usr/bin/env elixir

defmodule Frame do
  @derive [Access]
  defstruct rolls: [], score: 0, bonus: 0, bonusrolls: 0

  def add_roll(frame, pins) do
    frame |> Map.update(:score, 0, &(&1 + pins))
          |> Map.update(:rolls, [], &(&1 ++ [pins]))
          |> assign_bonusrolls
  end

  defp assign_bonusrolls(frame) do
    cond do
      frame |> is_spare?  -> frame |> Map.put(:bonusrolls, 1)
      frame |> is_strike? -> frame |> Map.put(:bonusrolls, 2)
      true                -> frame |> Map.put(:bonusrolls, 0)
    end
  end

  def add_bonus(frame, bonus) do
    cond do
      frame[:bonusrolls] > 0 -> frame |> Map.update(:bonus, 0, &(&1 + bonus))
                                      |> Map.update!(:bonusrolls, &(&1 - 1))
      true                   -> frame
    end
  end

  def get_score(frame), do: frame[:score]
  def get_rolls(frame), do: frame[:rolls] |> length
  def get_bonus(frame), do: frame[:bonus]

  def is_spare?(frame),  do: get_score(frame) == 10 and get_rolls(frame) > 1
  def is_strike?(frame), do: get_score(frame) == 10 and get_rolls(frame) == 1

end

defmodule Bowling do
  @derive [Access]
  defstruct frames: []

  def game(), do: %Bowling{frames: [%Frame{}] }

  def roll(g, pins) do
    g |> Map.update!(:frames, &(add_roll(&1, pins)))
      |> Map.update!(:frames, &(update_bonus(&1, pins)))
  end

  def score(g) do
    g[:frames] |> Enum.map(&(Frame.get_score(&1) + Frame.get_bonus(&1)))
               |> Enum.sum
  end

  defp add_roll([h|t], pins) do
    cond do
      [h|t] |> length == 10     -> [Frame.add_roll(h, pins) | t]
      h |> Frame.is_strike?     -> [Frame.add_roll(%Frame{}, pins), h | t ]
      h |> Frame.get_rolls == 2 -> [Frame.add_roll(%Frame{}, pins), h | t ]
      true                      -> [Frame.add_roll(h, pins) | t]
    end
  end

  defp update_bonus([h|t], pins) do
    [h | t |> Enum.map(&(Frame.add_bonus(&1, pins)))]
  end

end


ExUnit.start [trace: true, seed: 0]
defmodule BowlingTests do
  use ExUnit.Case, async: false

  setup do
    { :ok, [game: Bowling.game] }
  end

  defp get_score(rolls, game) do
    rolls |> Enum.reduce(game[:game], &(Bowling.roll(&2, &1)))
          |> Bowling.score
  end

  test "Test 20 misses", game do
    assert List.duplicate(0, 20) |> get_score(game) == 0
  end

  test "Test 20 hits of 1 pin", game do
    assert List.duplicate(1, 20) |> get_score(game) == 20
  end

  test "Test round without spares or strikes", game do
    assert [1,3, 5,2, 7,1, 3,3, 3,6, 2,3, 4,4, 6,2, 3,5, 1,4] 
           |> get_score(game) == 68
  end

  test "Test round with spares (not in last frame)", game do
    assert [3,5, 6,4, 2,4, 3,7, 8,2, 5,3, 4,4, 7,3, 0,4, 3,4] 
           |> get_score(game) == 96
  end

  test "Test round with spare in last frame", game do
    assert [3,5, 6,4, 2,4, 3,7, 8,2, 5,3, 4,4, 7,3, 0,4, 3,7,8]
           |> get_score(game) == 107
  end

  test "Test round with spares and a strike in last frame", game do
    assert [3,5, 6,4, 2,4, 3,7, 8,2, 5,3, 4,4, 7,3, 0,4, 3,7,10]
           |> get_score(game) == 109
  end

  test "Test round with strikes", game do
    assert [4,5, 10, 4,3, 4,5, 10, 6,4, 3,5, 7,3, 10,4,2]
           |> get_score(game) == 125
  end

  test "Test round with consecutive strikes", game do
    assert [4,5, 10, 4,3, 4,5, 10, 10, 10, 7,3, 10, 10,4,2]
           |> get_score(game) == 179
  end

  test "Test perfect game", game do
    assert List.duplicate(10, 12)
           |> get_score(game) == 300
  end

end

