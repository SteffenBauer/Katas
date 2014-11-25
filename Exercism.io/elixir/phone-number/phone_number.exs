defmodule Phone do

  @invalid "0000000000"

  @spec number(String.t) :: String.t
  def number(raw) do
    phone = raw 
          |> to_char_list
          |> Enum.filter(&(&1 >= ?0 and &1 <= ?9))
    cond do
      length(phone) < 10                      -> @invalid
      length(phone) > 11                      -> @invalid
      length(phone) == 11 and hd(phone) != ?1 -> @invalid
      length(phone) == 11 and hd(phone) == ?1 -> tl(phone) |> to_string
      true                                    -> phone |> to_string
    end
  end

  @spec area_code(String.t) :: String.t
  def area_code(raw) do
    raw |> number |> String.slice(0..2)
  end

  @spec pretty(String.t) :: String.t
  def pretty(raw) do
    phone = raw |> number
    area  = phone |> String.slice(0..2)
    first = phone |> String.slice(3..5)
    rest  = phone |> String.slice(6..9)
    "(#{area}) #{first}-#{rest}"
  end

end
