defmodule ListOps do
  # Please don't use any external modules (especially List) in your
  # implementation. The point of this exercise is to create these basic functions
  # yourself.
  # 
  # Note that `++` is a function from an external module (Kernel, which is
  # automatically imported) and so shouldn't be used either.
 
  @spec count(list) :: non_neg_integer
  def count(l), do: count(l,0)
  defp count([],    c), do: c
  defp count([_h|t],c), do: count(t,c+1)

  @spec reverse(list) :: list
  def reverse(l), do: reverse(l,[])
  defp reverse([],l),     do: l
  defp reverse([h|t], l), do: reverse(t, [h|l])

  @spec map(list, (any -> any)) :: list
  # Implementation a) of map: Stand-alone
  def map(l, f), do: map(l, f, [])
  defp map([],   _f, l), do: reverse(l)
  defp map([h|t], f, l), do: map(t, f, [f.(h)|l])

  # Implementation b) of map: Using reduce
  def map2(l, f) do
    mapper = &([f.(&1) | &2])
    reduce(l, [], mapper) |> reverse
  end

  @spec filter(list, (any -> as_boolean(term))) :: list
  def filter(l, f), do: filter(l, f, [])
  defp filter([], _f, l),  do: reverse(l)
  defp filter([h|t], f, l) do
    case f.(h) do
      true  -> filter(t, f, [h|l])
      false -> filter(t, f, l)
    end
  end

  @type acc :: any
  @spec reduce(list, acc, ((any, acc) -> acc)) :: acc
  def reduce([],    acc, _f), do: acc
  def reduce([h|t], acc, f),  do: reduce(t, f.(h, acc), f)

  @spec append(list, list) :: list
  def append(a, b) do
    a |> reverse |> do_append(b)
  end
  defp do_append([], b),    do: b
  defp do_append([h|t], b), do: do_append(t, [h|b])

  @spec concat([[any]]) :: [any]
  def concat(ll), do: ll |> reverse |> concat([])
  defp concat([],    l), do: l
  defp concat([h|t], l), do: concat(t, append(h,l))

end
