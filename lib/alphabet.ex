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

  @doc """
  Obtain a regex sigil with all valid symbols.

  Returns `~r/#{Regex.source(@symbols)}/`.

  ## Example

      iex> Alphabet.symbols
      ~r/#{Regex.source(@symbols)}/

  """
  @spec symbols() :: term()
  def symbols, do: @symbols

  @doc """
  Obtain a regex sigil with all valid propositional symbols.

  Returns `~r/#{Regex.source(@propositional_symbols)}/`.

  ## Example

      iex> Alphabet.propositional_symbols
      ~r/#{Regex.source(@propositional_symbols)}/

  """
  @spec propositional_symbols() :: term()
  def propositional_symbols, do: @propositional_symbols

  @doc """
  Obtain a regex sigil with all valid truthy symbols.

  Returns `~r/#{Regex.source(@truthy_symbols)}/`.

  ## Example

      iex> Alphabet.truthy_symbols
      ~r/#{Regex.source(@truthy_symbols)}/

  """
  @spec truthy_symbols() :: term()
  def truthy_symbols, do: @truthy_symbols

  @doc """
  Obtain a regex sigil with all valid punctuation symbols.

  Returns `~r/#{Regex.source(@punctuation)}/`.

  ## Example

      iex> Alphabet.punctuation
      ~r/#{Regex.source(@punctuation)}/

  """
  @spec punctuation() :: term()
  def punctuation, do: @punctuation

  @doc """
  Obtain a regex sigil with all valid logic connectives.

  Returns `~r/#{Regex.source(@connectives)}/`.

  ## Example

      iex> Alphabet.connectives
      ~r/#{Regex.source(@connectives)}/

  """
  @spec connectives() :: term()
  def connectives, do: @connectives

  @doc """
  Obtain the precedence of a given logical connective.

  Returns an integer.

  ## Example

      iex> Alphabet.connective_precedence(:!)
      4

  """
  @spec connective_precedence(atom) :: integer
  def connective_precedence(connective) when is_atom(connective) do
    {_, precedence} = Keyword.fetch(@connectives_precedence, connective)
    precedence
  end
end
