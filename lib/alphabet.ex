defmodule Alphabet do
  @moduledoc """
  A module to represents the propositional logic alphabet
  """

  @symbols ~r/[A-Z]|[01]|[\(\)]|[!&|>=]/
  @propositional_symbols ~r/[A-Z]/
  @truthy_symbols ~r/[01]/
  @punctuation ~r/[\(\)]/
  @connectives ~r/[!&|>=]/
  @connectives_precedence [&: 3, |: 2, >: 1, =: 0, !: 4]

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
      0

  """
  @spec connective_precedence(atom) :: integer
  def connective_precedence(connective) when is_atom(connective) do
    {_, precedence} = Keyword.fetch(@connectives_precedence, connective)
    precedence
  end

  @doc """
  Obtain the type of a symbol according to the propositional logic alphabet.

  Returns an atom.

  ## Example

      iex> Alphabet.symbol_type("=")
      :biconditional

  """
  @spec symbol_type(String.t()) :: atom()
  def symbol_type(symbol) when is_binary(symbol) do
    cond do
      String.match?(symbol, propositional_symbols()) -> :propositional
      String.match?(symbol, truthy_symbols()) -> :truthy
      String.match?(symbol, ~r/\(/) -> :open
      String.match?(symbol, ~r/\)/) -> :close
      String.match?(symbol, ~r/\!/) -> :negation
      String.match?(symbol, ~r/\&/) -> :conjunction
      String.match?(symbol, ~r/\|/) -> :disjunction
      String.match?(symbol, ~r/\>/) -> :implication
      String.match?(symbol, ~r/\=/) -> :biconditional
    end
  end
end
