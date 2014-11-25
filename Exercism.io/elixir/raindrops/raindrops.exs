defmodule Raindrops do

  @sounds [ {3, "Pling"}, {5, "Plang"}, {7, "Plong"} ]

  def convert(number) do
    case Enum.reduce(@sounds, {number, ""}, &sound(&2, &1)) do
      { n, ""}  -> to_string(n)
      {_n, str} -> str
    end
  end

  defp sound({n, str}, {f, sound}) when rem(n,f) == 0, do: {n, str <> sound}
  defp sound({n, str}, _),                             do: {n, str}

end
