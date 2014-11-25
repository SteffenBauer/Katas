#!/usr/bin/env elixir

ExUnit.start

defmodule ChopTests do
  use ExUnit.Case, async: true
  import Chop

  def chop(value, array), do: chop0(value, array)

  test "Test empty array" do
    assert -1 == chop(3, [])
  end  
  
  test "Test element not in array" do
    assert -1 == chop(3, [1])

    assert -1 == chop(0, [1, 3, 5])
    assert -1 == chop(2, [1, 3, 5])
    assert -1 == chop(4, [1, 3, 5])
    assert -1 == chop(6, [1, 3, 5])

    assert -1 == chop(0, [1, 3, 5, 7])
    assert -1 == chop(2, [1, 3, 5, 7])
    assert -1 == chop(4, [1, 3, 5, 7])
    assert -1 == chop(6, [1, 3, 5, 7])
    assert -1 == chop(8, [1, 3, 5, 7])
  end

  test "Test element in array" do
    assert 0  == chop(1, [1])

    assert 0  == chop(1, [1, 3, 5])
    assert 1  == chop(3, [1, 3, 5])
    assert 2  == chop(5, [1, 3, 5])

    assert 0  == chop(1, [1, 3, 5, 7])
    assert 1  == chop(3, [1, 3, 5, 7])
    assert 2  == chop(5, [1, 3, 5, 7])
    assert 3  == chop(7, [1, 3, 5, 7])
  end

end

