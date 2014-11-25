#!/usr/bin/env elixir

defmodule SimpleTree do
  def new, do: nil

  def insert(nil, val),                             do: {val, nil, nil}
  def insert({val, left, right}, val),              do: {val, left, right}
  def insert({vt, left, right}, val) when val < vt, do: {vt, insert(left, val), right}
  def insert({vt, left, right}, val),               do: {vt, left, insert(right, val)}

  def member?(nil, _),                           do: false
  def member?({val, _, _}, val),                 do: true
  def member?({vt, left, _}, val) when val < vt, do: member?(left, val)
  def member?({_, _, right}, val),               do: member?(right, val)

  def to_list(nil), do: []
  def to_list({val, left, right}), do: to_list(left) ++ [val|to_list(right)]

  def delete(nil, _),                 do: nil
  def delete({val, nil, nil}, val),   do: nil
  def delete({val, left, nil}, val),  do: left
  def delete({val, nil, right}, val), do: right
  def delete({vt, left, right}, val) when val < vt, do: {vt, delete(left, val), right}
  def delete({vt, left, right}, val) when val > vt, do: {vt, left, delete(right, val)}
  def delete({val, left, right}, val) do
    case :random.uniform 2 do
      1 -> succ = find_min(right)
           {succ, left, delete(right, succ)}
      2 -> succ = find_max(left)
           {succ, delete(left, succ), right}
    end
  end

  defp find_min({val, nil, _}), do: val
  defp find_min({_, left, _}),  do: find_min(left)
  defp find_max({val, _, nil}), do: val
  defp find_max({_, _, right}), do: find_max(right)

end

ExUnit.start [trace: true, seed: 0]
defmodule SimpleTreeTests do
  use ExUnit.Case, async: false

  setup do
    tree = SimpleTree.new
    |> SimpleTree.insert(5)
    |> SimpleTree.insert(3)
    |> SimpleTree.insert(8)
    |> SimpleTree.insert(7)
    {:ok, [tree: tree]}
  end

  test "Test empty tree" do
    assert SimpleTree.new == nil
  end

  test "Test element inserts" do
    tree1 = SimpleTree.new
    tree2 = SimpleTree.insert(tree1, 5)
    tree3 = SimpleTree.insert(tree2, 3)
    tree4 = SimpleTree.insert(tree3, 8)
    assert tree2 == {5, nil, nil}
    assert tree3 == {5, {3, nil, nil}, nil}
    assert tree4 == {5, {3, nil, nil}, {8, nil, nil}}
  end

  test "Test membership", context do
    assert SimpleTree.member?(context[:tree], 5)
    assert SimpleTree.member?(context[:tree], 3)
    assert SimpleTree.member?(context[:tree], 8)
    assert SimpleTree.member?(context[:tree], 7)
    refute SimpleTree.member?(context[:tree], 1)
    refute SimpleTree.member?(context[:tree], "abc")
  end

  test "Test to_list", context do
    assert SimpleTree.to_list(context[:tree]) == [3,5,7,8]
  end

  test "Test delete", context do
    assert SimpleTree.delete(context[:tree], 3)
           |> SimpleTree.to_list == [5,7,8]
    assert SimpleTree.delete(context[:tree], 8)
           |> SimpleTree.to_list == [3,5,7]
    assert SimpleTree.delete(context[:tree], 7)
           |> SimpleTree.to_list == [3,5,8]
    assert SimpleTree.delete(context[:tree], 5)
           |> SimpleTree.to_list == [3,7,8]
           
  end

end

