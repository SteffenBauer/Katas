defmodule Sublist do
  @doc """
  Returns whether the first list is a sublist or a superlist of the second list
  and if not whether it is equal or unequal to the second list.
  """
  def compare(a, b) do
    cond do
       a === b      -> :equal
       is_sub?(a,b) -> :sublist
       is_sub?(b,a) -> :superlist
       true         -> :unequal
    end
  end

  defp is_sub?(a, b) do
    cond do
      length(a) > length(b)         -> false
      Enum.take(b, length(a)) === a -> true
      true                          -> is_sub?(a, tl(b))
    end
  end

end
