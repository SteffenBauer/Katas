defmodule Graph do
  defstruct attrs: [], nodes: [], edges: []
  
  
  
end

defmodule Dot do
  defmacro graph(ast) do
    ast |> parse_ast |> Macro.escape
  end
  
  def parse_ast([do: ast]), do: parse_ast(ast, %Graph{})

  def parse_ast(nil, graph), do: graph

  def parse_ast({:__block__, _, []}, graph),    do: graph
  def parse_ast({:__block__, _, [h|t]}, graph), do: parse_ast({:__block__, [], t}, parse_ast(h, graph))

  def parse_ast({:graph, _, nil},           graph), do: update_attrs(graph, [])
  def parse_ast({:graph, _, [[]]},          graph), do: update_attrs(graph, [])
  def parse_ast({:graph, _, [[{kw, val}]]}, graph), do: update_attrs(graph, [{kw, val}])

  def parse_ast({var, _, nil},           graph), do: update_nodes(graph, var, [])
  def parse_ast({var, _, [[]]},          graph), do: update_nodes(graph, var, [])
  def parse_ast({var, _, [[{kw, val}]]}, graph), do: update_nodes(graph, var, [{kw, val}])

  def parse_ast({:--, _, [{v1, _, _}, {v2, _, nil}]},           graph), do: update_edges(graph, v1, v2, [])
  def parse_ast({:--, _, [{v1, _, _}, {v2, _, [[]]}]},          graph), do: update_edges(graph, v1, v2, [])
  def parse_ast({:--, _, [{v1, _, _}, {v2, _, [[{kw, val}]]}]}, graph), do: update_edges(graph, v1, v2, [{kw, val}])

  def parse_ast(_, _), do: raise ArgumentError

  defp update_attrs(graph, attr),       do: Map.update(graph, :attrs, attr,           &(Enum.sort attr ++ &1))
  defp update_nodes(graph, var, kw),    do: Map.update(graph, :nodes, [{var, kw}],    &(Enum.sort [{var, kw}] ++ &1))
  defp update_edges(graph, v1, v2, kw), do: Map.update(graph, :edges, [{v1, v2, kw}], &(Enum.sort [{v1, v2, kw}] ++ &1))
end


defmodule DotExample do
  require Dot
  def make_graph do
    mygraph = Dot.graph do 
      graph [title: "A small graph of three nodes"]

      a [label: "This is node A"]
      c [label: "This is node B"]
      b [label: "This is node C"]

      a -- b [color: :blue]
      b -- c [color: :green]
      c -- a [color: :red]
    end
    IO.inspect mygraph
  end
end

DotExample.make_graph
