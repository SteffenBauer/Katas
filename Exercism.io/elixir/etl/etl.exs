defmodule ETL do
  @doc """
  Transform an index into an inverted index.

  ## Examples

  iex> ETL.transform(%{"a" => ["ABILITY", "AARDVARK"]}, "b" => ["BALLAST", "BEAUTY"]})
  %{"ability" => "a", "aardvark" => "a", "ballast" => "b", "beauty" =>"b"}
  """
  @spec transform(Dict.t) :: map() 
  def transform(input) do
    Enum.reduce(input, %{}, fn {k,v}, acc -> put_all_entries(acc,k,v) end)
  end
  
  defp put_all_entries(map, oldkey, oldvalues) do
    Enum.reduce(oldvalues, map, fn v, acc -> Map.put_new(acc, String.downcase(v), oldkey) end)
  end
  
end
