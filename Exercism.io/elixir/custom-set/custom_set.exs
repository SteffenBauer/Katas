
defprotocol MySet do
  def insert(set, data)
  def delete(set, data)
  def member?(set, data)
  def to_list(set)
end

defmodule SetList do
  @derive [Access]
  defstruct set: []
  
  defimpl MySet do
    def insert(l, e), do: %SetList{set: [e|l[:set]]}
    def delete(l, e), do: %SetList{set: Enum.reduce(l[:set], [], &(if(&1 === e, do: &2, else: [&1 | &2])))}
    def member?(l, e), do: e in l[:set]
    def to_list(l), do: l[:set]
  end
end

defmodule SetSimpleTree do
  @derive [Access]
  defstruct set: nil

  defimpl MySet do
    def insert(tree, e), do: %SetSimpleTree{set: tinsert(tree[:set], e)}
    def delete(tree, e), do: %SetSimpleTree{set: tdelete(tree[:set], e)}
    def member?(tree, e), do: tmember?(tree[:set], e)
    def to_list(tree), do: tto_list(tree[:set])

    defp tinsert(nil, val),                             do: {val, nil, nil}
    defp tinsert({val, left, right}, val),              do: {val, left, right}
    defp tinsert({vt, left, right}, val) when val < vt, do: {vt, tinsert(left, val), right}
    defp tinsert({vt, left, right}, val),               do: {vt, left, tinsert(right, val)}
    
    defp tdelete(nil, _),                 do: nil
    defp tdelete({val, nil, nil}, val),   do: nil
    defp tdelete({val, left, nil}, val),  do: left
    defp tdelete({val, nil, right}, val), do: right
    defp tdelete({val, left, right}, val) do
      case :random.uniform 2 do
        1 -> succ = find_min(right); {succ, left, tdelete(right, succ)}
        2 -> succ = find_max(left);  {succ, tdelete(left, succ), right}
      end
    end
    defp tdelete({vt, left, right}, val) when val < vt, do: {vt, tdelete(left, val), right}
    defp tdelete({vt, left, right}, val),               do: {vt, left, tdelete(right, val)}

    defp tmember?(nil, _),                           do: false
    defp tmember?({val, _, _}, val),                 do: true
    defp tmember?({vt, left, _}, val) when val < vt, do: tmember?(left, val)
    defp tmember?({_, _, right}, val),               do: tmember?(right, val)

    defp tto_list(nil), do: []
    defp tto_list({val, left, right}), do: tto_list(left) ++ [val|tto_list(right)]

    defp find_min({val, nil, _}), do: val
    defp find_min({_, left, _}),  do: find_min(left)
    defp find_max({val, _, nil}), do: val
    defp find_max({_, _, right}), do: find_max(right)
  end
end


defmodule CustomSet do
  @behaviour Set
  @derive [Access]
  defstruct set: %SetSimpleTree{}
#  defstruct set: %SetList{}

  defp add_new_element(set, element) do
    if(MySet.member?(set, element), do: set, else: MySet.insert(set, element))
  end

  def new(),   do: %CustomSet{}
  def new([]), do: %CustomSet{}
  def new(l) do
    %CustomSet{set: Enum.reduce(l, %CustomSet{}[:set], &(add_new_element(&2,&1))) }
  end
  
  def empty(_s), do: %CustomSet{}
  
  def size(s), do: MySet.to_list(s[:set] ) |> length

  def member?(s, e), do: MySet.member?(s[:set] , e)

  def equal?(s1, s2) do
    MySet.to_list(s1[:set] ) |> Enum.sort === MySet.to_list(s2[:set] ) |> Enum.sort
  end
  
  def to_list(s) do
    MySet.to_list(s[:set] ) |> Enum.sort
  end

  def union(s1, s2) do
    %CustomSet{set: Enum.reduce(MySet.to_list(s1[:set] ), s2[:set] , &(add_new_element(&2,&1))) }
  end

  def delete(s, e) do
    %CustomSet{set: MySet.delete(s[:set], e) }
  end

  def put(s, e) do 
    %CustomSet{set: add_new_element(s[:set], e)}
  end

  def difference(s1, s2) do
    %CustomSet{set: Enum.reduce(MySet.to_list(s1[:set]), %CustomSet{}[:set], 
                              &(if(MySet.member?(s2[:set], &1), do: &2, else: MySet.insert(&2, &1)))) }
  end

  def intersection(s1, s2) do
    %CustomSet{set: Enum.reduce(MySet.to_list(s1[:set]), %CustomSet{}[:set], 
                              &(if(MySet.member?(s2[:set], &1), do: MySet.insert(&2, &1), else: &2))) }
  end

  def disjoint?(s1, s2) do
    Stream.map(MySet.to_list(s1[:set]), &(not MySet.member?(s2[:set], &1))) |> Enum.all?
  end

  def subset?(s1, s2) do
    Stream.map(MySet.to_list(s1[:set]), &(MySet.member?(s2[:set], &1))) |> Enum.all?
  end

  defimpl Inspect do
    def inspect(%CustomSet{set: set}, _opts) do
      "#<CustomSet #{inspect MySet.to_list(set) |> Enum.sort}>"
    end
  end

end
