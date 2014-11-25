defmodule Minesweeper do

  @spec annotate([String.t]) :: [String.t]
  def annotate(board) do
    board |> Enum.map(&to_char_list/1)
          |> add_coordinates
          |> make_annotated_board
          |> Enum.map(&to_string/1)
  end

  # Transform the grid [ 'xxx', 'xxx', ...]
  # to [ [{'x', {0, 0}}, {'x', {1, 0}}, ...], [ ... ], ... ]
  defp add_coordinates(board) do
    add_coord(board, [], [], 0, 0)
  end
  
  # Add coordinates {x, y} to a grid cell. Continue with next cell on that line.
  defp add_coord([[hx|tx]|ty], bt, bi, x, y) do
    add_coord([tx|ty], [{hx,{x,y}}|bt], bi, x+1, y)
  end
  
  # We indexed a line. Continue with the next line.
  defp add_coord([ [] |ty], bt, bi, _, y) do
    add_coord(ty, [], [Enum.reverse(bt)|bi], 0, y+1)
  end
  
  # Each grid cell got its coordinates. Return the indexed grid.
  defp add_coord([], _, bi, _, _) do
    Enum.reverse(bi)
  end

  # Annotation.
  #  - Get a list of coordinates of all mines.
  #  - Make a new grid containing the number of surrounding mines.
  defp make_annotated_board(board) do
    is_mine?        = fn {?*, _} -> true; 
                         _       -> false end
    get_coordinates = fn {_, coord} -> coord end
    mines = board 
         |> List.flatten
         |> Enum.filter(is_mine?)
         |> Enum.map(get_coordinates)
    do_annotation(board, mines, [], [])
  end

  # A mine in a grid cell:
  #  - Put a mine into the annotated grid.
  #  - Annotate next cell in the line
  defp do_annotation([[{?*, _}|tx]|ty], mines, bt, ba) do
    do_annotation([tx|ty], mines, [?*|bt], ba)
  end

  # Empty grid cell.
  #  - Put the number of surrounding mines into the annotated grid
  defp do_annotation([[{?\s, {x, y}}|tx]|ty], mines, bt, ba) do
    case number_of_mines(mines, x, y) do
      0 -> do_annotation([tx|ty], mines, [?\s   |bt], ba)
      n -> do_annotation([tx|ty], mines, [(?0+n)|bt], ba)
    end
  end

  # A complete line was annotated.
  #  - Annotate the next line
  defp do_annotation([ [] |ty], mines, bt, ba) do 
    do_annotation(ty, mines, [], [Enum.reverse(bt)|ba])
  end

  # End of recursion. 
  #  - Return the annotated grid
  defp do_annotation([], _, _, ba) do
    Enum.reverse(ba)
  end

  # Number of mines around the coordinates {x, y}
  defp number_of_mines(mines, x, y) do
    n = neighbours(x,y)
    mines |> Enum.filter(&(&1 in n)) |> length
  end

  # Coordinates of neighbours of {x, y}
  defp neighbours(x, y) do
    for xn <- -1..1, 
        yn <- -1..1, 
        not(xn == 0 and yn == 0), do: {x+xn, y+yn}
  end

end
