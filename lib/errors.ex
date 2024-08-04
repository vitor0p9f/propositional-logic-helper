defmodule UnexpectedCharacterError do
  @moduledoc """
  A module to define a custom error, that is thrown when a character doesn't belong to the propositional logic alphabet.
  """

  defexception [:message]
end
