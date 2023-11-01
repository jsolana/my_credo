defmodule MyModule do
  @moduledoc """
  Creeeedo is fun as moduledoc line
  """

  def sum(a, b) when is_number(a) and is_number(b), do: a + b
  # Creeeedo as a function comment
  def sum(_a, _b), do: 0
end
