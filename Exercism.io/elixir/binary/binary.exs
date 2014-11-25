defmodule Binary do

  @spec to_decimal(String.t) :: non_neg_integer
  def to_decimal(string) do
    string |> String.reverse 
           |> String.codepoints
           |> to_decimal(0, 1)
  end

  def to_decimal([],      num, _),      do: num
  def to_decimal(["1"|t], num, factor), do: to_decimal(t, num+factor, factor*2)
  def to_decimal(["0"|t], num, factor), do: to_decimal(t, num,        factor*2)
  def to_decimal([_  |_], _,   _),      do: 0
  
end
