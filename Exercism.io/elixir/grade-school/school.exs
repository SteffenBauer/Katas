defmodule School do

  @spec add(Dict.t, String.t, pos_integer) :: Dict.t
  def add(db, name, grade) do
    Map.update(db, grade, [name], &([name | &1]))
  end

  @spec grade(Dict.t, pos_integer) :: [String]
  def grade(db, grade) do
    db[grade] || []
  end

  @spec sort(Dict) :: Dict.t
  def sort(db) do
    Enum.reduce db, %{}, fn {k,v}, acc -> Map.put(acc, k, Enum.sort(v)) end
  end

end
