defmodule Meetup do

  @days [monday: 1, tuesday: 2, wednesday: 3, 
         thursday: 4, friday: 5, saturday: 6, 
         sunday: 7]

  def meetup(year, month, weekday, schedule) do
    daycode = @days[weekday]
    1..(:calendar.last_day_of_the_month(year, month))
      |> Enum.filter(&(right_weekday?(year, month, &1, daycode)))
      |> scheduled_day(schedule)
      |> to_datetuple(year, month)
  end

  defp right_weekday?(year, month, day, daycode) do
    :calendar.day_of_the_week(year, month, day) == daycode
  end

  defp scheduled_day(days, :teenth), do: Enum.find(days, &(&1 >= 13))
  defp scheduled_day(days, :first),  do: Enum.at(days, 0)
  defp scheduled_day(days, :second), do: Enum.at(days, 1)
  defp scheduled_day(days, :third),  do: Enum.at(days, 2)
  defp scheduled_day(days, :fourth), do: Enum.at(days, 3)
  defp scheduled_day(days, :last),   do: List.last(days)

  defp to_datetuple(day, year, month), do: {year, month, day}

end
