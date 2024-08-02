defmodule Alphabet do
  @moduledoc """
  A module to represents the propositional logic alphabet
  """

  @symbols ~r/[A-Z]|[01]|[\(\)]|[!&|>=]/
  @propositional_symbols ~r/[A-Z]/
  @truthy_symbols ~r/01/
  @punctuation ~r/\(\)/
  @connectives ~r/!&|>=/
  @connectives_precedence [!: 4, &: 3, |: 2, >: 1, =: 0]

end
