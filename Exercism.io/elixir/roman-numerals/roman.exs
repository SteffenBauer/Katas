defmodule Roman do

  @spec numerals(pos_integer) :: String.t

  @romannums [ {1000, "M"}, {900, "CM"}, {500, "D"}, {400, "CD" },
               { 100, "C"}, { 90, "XC"}, { 50, "L"}, { 40, "XL" },
               {  10, "X"}, {  9, "IX"}, {  5, "V"}, {  4, "IV" },
               {   1, "I"} ]

  def numerals(number, [{num, rchr}|t] \\ @romannums) do
    cond do
      number == 0   -> ""
      number >= num -> rchr <> numerals(number - num, [{num, rchr}|t])
      true          -> numerals(number, t)
    end
  end

end
