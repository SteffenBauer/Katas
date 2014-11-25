
defmodule BinTree do
  defstruct value: nil, left: nil, right: nil
end

defmodule BinTreeZip do
  defstruct focus: nil, trail: :focus
end

defmodule Zipper do
  alias BinTree, as: BT
  alias BinTreeZip, as: Z
  
  def from_tree(bt), do: %BinTreeZip{ focus: bt, trail: [] }

  def to_tree(%Z{focus: f, trail: []}), do: f
  def to_tree(%Z{focus: f, trail: [{:left, v, r} | trail]}) do
    to_tree(%Z{focus: %BT{value: v, left: f, right: r}, trail: trail})
  end
  def to_tree(%Z{focus: f, trail: [{:right, v, l} | trail]}) do
    to_tree(%Z{focus: %BT{value: v, left: l, right: f}, trail: trail})
  end

  def value(%Z{focus: nil}),           do: nil
  def value(%Z{focus: %BT{value: v}}), do: v

  def left(%Z{focus: %BT{left: nil}}), do: nil
  def left(%Z{focus: %BT{value: v, left: l, right: r}, trail: trail}) do
    %Z{focus: l, trail: [{:left, v, r} | trail]}
  end

  def right(%Z{focus: %BT{right: nil}}), do: nil
  def right(%Z{focus: %BT{value: v, left: l, right: r}, trail: trail}) do
    %Z{focus: r, trail: [{:right, v, l} | trail]}
  end

  def up(%Z{trail: []}), do: nil
  def up(%Z{focus: f, trail: [{:left, v, r} | trail]}) do
    %Z{focus: %BT{value: v, left: f, right: r}, trail: trail}
  end
  def up(%Z{focus: f, trail: [{:right, v, l} | trail]}) do
    %Z{focus: %BT{value: v, left: l, right: f}, trail: trail}
  end

  def set_value(%Z{focus: f, trail: trail}, value), do: %Z{ focus: %{ f | :value => value}, trail: trail }
  def set_left( %Z{focus: f, trail: trail}, l),     do: %Z{ focus: %{ f | :left  => l},     trail: trail }
  def set_right(%Z{focus: f, trail: trail}, r),     do: %Z{ focus: %{ f | :right => r},     trail: trail }

end


ExUnit.start [trace: true, seed: 0]
defmodule ZipperTest do
  use ExUnit.Case, async: false
  import Zipper

  defimpl Inspect, for: BT do
    import Inspect.Algebra

    def inspect(%BinTree{value: v, left: l, right: r}, opts) do
      concat ["(", Kernel.inspect(v, opts),
              ":", (if l, do: Kernel.inspect(l, opts), else: ""),
              ":", (if r, do: Kernel.inspect(r, opts), else: ""),
              ")"]
    end
  end

  defp bt(value, left, right), do: %BinTree{value: value, left: left, right: right}
  defp leaf(value), do: %BinTree{value: value}

  defp t1, do: bt(1, bt(2, nil,     leaf(3)), leaf(4))
  defp t2, do: bt(1, bt(5, nil,     leaf(3)), leaf(4))
  defp t3, do: bt(1, bt(2, leaf(5), leaf(3)), leaf(4))
  defp t4, do: bt(1, leaf(2),                 leaf(4))
  defp t5, do: bt(1, bt(2, nil, leaf(3)),
                     bt(6, leaf(7), leaf(8)))

  test "Data is retained" do
    assert (t1 |> from_tree |> to_tree) == t1
  end

  test "left, right and value" do
    assert (t1 |> from_tree |> left |> right |> value) == 3
  end

  test "left, right, up and value" do
    assert (t1 |> from_tree |> left |> right |> up |> value) == 2
  end

  test "dead end" do
    assert (t1 |> from_tree |> left |> left) == nil
  end

  test "nothing above root node" do
    assert (t1 |> from_tree |> up) == nil
  end

  test "tree from deep focus" do
    assert (t1 |> from_tree |> left |> right |> to_tree) == t1
  end

  test "set_value" do
    assert (t1 |> from_tree |> left |> set_value(5) |> to_tree) == t2
  end

  test "set_left with leaf" do
    assert (t1 |> from_tree |> left |> set_left(leaf(5)) |> to_tree) == t3
  end
  
  test "set_right with nil" do
    assert (t1 |> from_tree |> left |> set_right(nil) |> to_tree) == t4
  end
  
  test "set_right with subtree" do
    assert (t1 |> from_tree |> set_right(bt(6, leaf(7), leaf(8))) |> to_tree) == t5
  end

end
