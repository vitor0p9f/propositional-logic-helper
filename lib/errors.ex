defmodule UnexpectedCharacterError do
  @moduledoc """
  A module to define a custom error, that is thrown when a character doesn't belong to the propositional logic alphabet.
  """

  defexception [:message]
end

defmodule SyntaxError do
  @moduledoc """
  Occurs when the parser encounters a syntax error.
  """

  defexception [:message]
end
