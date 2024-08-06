defmodule Parser do
  @moduledoc """
  Syntax verification of propositional logic.
  """

  @next_allowed_symbols %{
    propositional_and_truthy: [:close, :conjunction, :disjunction, :implication, :biconditional],
    close: [:close, :conjunction, :disjunction, :implication, :biconditional],
    open: [:propositional, :truthy, :open, :negation],
    negation: [:propositional, :truthy, :open, :negation],
    other_connectives: [:propositional, :truthy, :open, :negation]
  }

  @doc """
  Verify the syntax of an expression belonging to propositional logic.

  Returns `:ok` when the syntax is right.

  Raise `SyntaxError` when encountering a syntax error.

  ## Example

      iex> Parser.verify([])
      :ok

      iex> Parser.verify(["!","!","A"])
      :ok

      iex> Parser.verify(["!","&","A"])
      ** (SyntaxError) the '&' symbol cannot be after the '!' symbol.
  """
  @spec verify(list(String.t())) :: :ok
  def verify([]), do: :ok

  def verify([symbol]) do
    unless String.match?(symbol, Alphabet.propositional_symbols()) or
             String.match?(symbol, Alphabet.truthy_symbols()) do
      raise SyntaxError,
        message: "connectives or punctuation cannot be considered true or false."
    end

    :ok
  end

  def verify(list = [head, second | tail]) when is_list(list) do
    allowed_symbols =
      cond do
        String.match?(head, Alphabet.propositional_symbols()) or
            String.match?(head, Alphabet.truthy_symbols()) ->
          @next_allowed_symbols[:propositional_and_truthy]

        String.match?(head, Alphabet.punctuation()) and head == "(" ->
          @next_allowed_symbols[:open]

        String.match?(head, Alphabet.punctuation()) and head == ")" ->
          @next_allowed_symbols[:close]

        String.match?(head, Alphabet.connectives()) and head == "!" ->
          @next_allowed_symbols[:negation]

        String.match?(head, Alphabet.connectives()) and head != "!" ->
          @next_allowed_symbols[:other_connectives]
      end

    check_symbol(allowed_symbols, head, second)

    verify([second | tail])
  end

  defp check_symbol(allowed_symbols, previous_symbol, symbol) do
    unless Enum.member?(allowed_symbols, Alphabet.symbol_type(symbol)) do
      raise SyntaxError,
        message: "the '#{symbol}' symbol cannot be after the '#{previous_symbol}' symbol."
    end
  end
end
