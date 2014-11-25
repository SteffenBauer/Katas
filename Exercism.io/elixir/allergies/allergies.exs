defmodule Allergies do
  use Bitwise
  
  @allergies [ "eggs", "peanuts", "shellfish", "strawberries", "tomatoes", "chocolate", "pollen", "cats" ]

  @spec list(non_neg_integer) :: [String.t]
  def list(flags), do: list(flags, [], @allergies)

  defp list(_flags, allergylist, []),   do: allergylist
  defp list( flags, allergylist, [h|t]) do
    case flags &&& 1 do
      1 -> list(flags >>> 1, allergylist ++ [h], t)
      0 -> list(flags >>> 1, allergylist, t)
    end
  end

  @spec allergic_to?(non_neg_integer, String.t) :: boolean
  def allergic_to?(flags, item), do: allergic_to?(flags, item, @allergies)

  defp allergic_to?(_flags, _item, []),        do: false
  defp allergic_to?( flags,  item, [item|_t]), do: (flags &&& 1) == 1
  defp allergic_to?( flags,  item, [_h  | t]), do: allergic_to?(flags >>> 1, item, t)
end
