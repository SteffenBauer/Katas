#!/usr/bin/env elixir

defmodule Lists do
  
# P01: Find the last element of a list
  def get_last([]),                  do: nil
  def get_last([ h|t]) when t == [], do: h
  def get_last([_h|t]),              do: get_last t

# P02: Find the last but one element of a list
  def get_second_last([]),                       do: nil
  def get_second_last([_h     |t]) when t == [], do: nil
  def get_second_last([ h1,_h2|t]) when t == [], do: h1
  def get_second_last([_h     |t]),              do: get_second_last t

# P03: Find the kth element of a list
  def get_kth([],     _n), do: nil
  def get_kth([h|_t],  1), do: h
  def get_kth([_h|t],  n), do: get_kth(t, n-1)

# P04: Find the number of elements of a list
  def get_len(l), do: get_len(l, 0)
  def get_len([],     n), do: n
  def get_len([_h|t], n), do: get_len(t, n+1)

# P05: Reverse a list
  def reverse(l), do: reverse(l, [])
  def reverse([],    l), do: l
  def reverse([h|t], l), do: reverse(t, [h] ++ l)

# P06: Find out whether a list is a palindrome
  def is_palindrome?(l), do: l == reverse(l)

# P07: Flatten a nested list structure
  def flatten([]),    do: []
  def flatten([h|t]), do: flatten(h) ++ flatten(t)
  def flatten(h),     do: [h]

# P08: Eliminate consecutive duplicates of list elements
  def compress(l), do: compress(l, [])
  def compress([], l),   do: l
  def compress([h|t], l) do
    cond do
      h == get_last(l) -> compress(t, l)
      true             -> compress(t, l ++ [h])
    end
  end

# P09: Pack consecutive duplicates of list elements into sublists
  def pack([]),    do: []
  def pack([h|t]), do: pack(t, [], [h])
  def pack([], pck, acc), do: pck ++ [acc]
  def pack([h|t], pck, acc) when (h == hd acc), do: pack(t, pck, acc ++ [h])
  def pack([h|t], pck, acc),                    do: pack(t, pck ++ [acc], [h])

# P10: Run-length encoding of a list
  def encode(l), do: pack(l) |> encode([])
  def encode([], acc), do: acc
  def encode([h|t], acc), do: encode(t, acc ++ [[length(h), hd(h)]])

# P11: Modified run-length encoding
  def encode_modified(l), do: pack(l) |> encode_modified([])
  def encode_modified([], acc), do: acc
  def encode_modified([h|t], acc) when length(h) > 1, do: encode_modified(t, acc ++ [[length(h), hd(h)]])
  def encode_modified([h|t], acc),                    do: encode_modified(t, acc ++ h)
  
# P12: Decode a run-length encoded list
  def decode([]),        do: []
  def decode([[n,h]|t]), do: decode(t, List.duplicate(h,n))
  def decode([   h |t]), do: decode(t, [h])
  def decode([], acc), do: acc
  def decode([[n,h]|t], acc), do: decode(t, acc ++ List.duplicate(h,n))
  def decode([   h |t], acc), do: decode(t, acc ++ [h])

# P13: Run-length encoding of a list (direct solution)
  def encode_direct([]),    do: []
  def encode_direct([h|t]), do: encode_direct(t, h, 1, [])
  def encode_direct([], e, 1, acc), do: acc ++ [e]
  def encode_direct([], e, n, acc), do: acc ++ [[n, e]]
  def encode_direct([h|t], e, n, acc) when e == h, do: encode_direct(t, e, n+1, acc)
  def encode_direct([h|t], e, 1, acc),             do: encode_direct(t, h, 1, acc ++ [e])
  def encode_direct([h|t], e, n, acc),             do: encode_direct(t, h, 1, acc ++ [[n, e]])

# P14: Duplicate the elements of a list
  def duplicate([]),    do: []
  def duplicate([h|t]), do: duplicate(t, [h, h])
  def duplicate([],    acc), do: acc
  def duplicate([h|t], acc), do: duplicate(t, acc ++ [h, h])

# P15: Duplicate the elements of a list a given number of times
  def duplicate_n([], _n), do: []
  
  
end


ExUnit.start

defmodule ListsTests do
  use ExUnit.Case, async: true
  
  test "P01 Test get_last" do
    assert Lists.get_last([]) == nil
    assert Lists.get_last([3]) == 3
    assert Lists.get_last([4,3,2,1]) == 1
  end
  
  test "P02 Test get_second_last" do
    assert Lists.get_second_last([]) == nil
    assert Lists.get_second_last([3]) == nil
    assert Lists.get_second_last([4,3,2,1]) == 2
  end

  test "P03 Test get_kth" do
    assert Lists.get_kth([], 3) == nil
    assert Lists.get_kth([1,2], 3) == nil
    assert Lists.get_kth([4,3,2,1], 2) == 3
  end

  test "P04 Test get_len" do
    assert Lists.get_len([]) == 0
    assert Lists.get_len([4]) == 1
    assert Lists.get_len([4,3,2,1]) == 4
  end

  test "P05 Test reverse" do
    assert Lists.reverse([]) == []
    assert Lists.reverse([3]) == [3]
    assert Lists.reverse([3,2,1]) == [1,2,3]
    assert Lists.reverse([4,3,2,1]) == [1,2,3,4]
  end
  
  test "P06 Test is_palindrome?" do
    assert Lists.is_palindrome?([])
    assert Lists.is_palindrome?([3])
    assert Lists.is_palindrome?([4,3,1,3,4])
    refute Lists.is_palindrome?([4,3,1,2])
  end
  
  test "P07 Test flatten" do
    assert Lists.flatten([]) == []
    assert Lists.flatten([1,2,3]) == [1,2,3]
    assert Lists.flatten([1,[2,3]]) == [1,2,3]
    assert Lists.flatten([[1,2,[3,4]],[[1,2],3]]) == [1,2,3,4,1,2,3]
    assert Lists.flatten([[],[1,2,[]],[1,[2,[3,[],4],[],[5]]]]) == [1,2,1,2,3,4,5]
  end

  test "P08 Test compress" do
    assert Lists.compress([]) == []
    assert Lists.compress([3]) == [3]
    assert Lists.compress([1,2,3]) == [1,2,3]
    assert Lists.compress([4,4,4,4,3,3,3,2,2,1]) == [4,3,2,1]
  end

  test "P09 Test pack" do
    assert Lists.pack([]) == []
    assert Lists.pack([3]) == [[3]]
    assert Lists.pack([1,2,3]) == [[1],[2],[3]]
    assert Lists.pack([1,1,1,1,2,3,3,1,1,4,5,5,5]) == [[1,1,1,1],[2],[3,3],[1,1],[4],[5,5,5]]
  end

  test "P10 Test encode" do
    assert Lists.encode([]) == []
    assert Lists.encode([3]) == [[1,3]]
    assert Lists.encode([1,2,3]) == [[1,1],[1,2],[1,3]]
    assert Lists.encode([1,1,1,1,2,3,3,1,1,4,5,5,5]) == [[4,1],[1,2],[2,3],[2,1],[1,4],[3,5]]
  end

  test "P11 Test encode_modified" do
    assert Lists.encode_modified([]) == []
    assert Lists.encode_modified([3]) == [3]
    assert Lists.encode_modified([1,2,3]) == [1,2,3]
    assert Lists.encode_modified([1,1,1,1,2,3,3,1,1,4,5,5,5]) == [[4,1],2,[2,3],[2,1],4,[3,5]]
  end

  test "P12 Test decode" do
    assert Lists.decode([]) == []
    assert Lists.decode([3]) == [3]
    assert Lists.decode([1,2,3]) == [1,2,3]
    assert Lists.decode([[4,1],2,[2,3],[2,1],4,[3,5]]) == [1,1,1,1,2,3,3,1,1,4,5,5,5]
  end

  test "P13 Test encode_direct" do
    assert Lists.encode_direct([]) == []
    assert Lists.encode_direct([3]) == [3]
    assert Lists.encode_direct([1,2,3]) == [1,2,3]
    assert Lists.encode_direct([1,1,1,1,2,3,3,1,1,4,5,5,5]) == [[4,1],2,[2,3],[2,1],4,[3,5]]
  end
  
  test "P14 Test duplicate" do
    assert Lists.duplicate([]) == []
    assert Lists.duplicate([3]) == [3,3]
    assert Lists.duplicate([1,2,3]) == [1,1,2,2,3,3]
    assert Lists.duplicate([1,2,3,3,4]) == [1,1,2,2,3,3,3,3,4,4]
  end
  
end
