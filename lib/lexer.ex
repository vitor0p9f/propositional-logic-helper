defmodule Lexer do
  @moduledoc """
  A module for the verification of symbols within logical expressions.
  """

  @doc """
  Check whether all characters within a list belong to the propositional logic alphabet.

  Returns `:ok` when all characters in the list belong to the alphabet.

  Raise `UnexpectedCharacterError,` when one of the characters within the list does not belong to the alphabet.

  ## Example

      iex> Lexer.analyze(["!","&","|",">","="])
      :ok

      iex> Lexer.analyze(["!","&","|",">","=","#"])
      ** (UnexpectedCharacterError) the '#' symbol doesn't belong to propositional logic alphabet.
  """
  @spec analyze(list(String.t())) :: :ok
  def analyze(list) when is_list(list), do: check(list)

  defp check([]), do: :ok

  defp check([head | tail]) do
    unless String.match?(head, Alphabet.symbols()) do
      raise UnexpectedCharacterError,
        message: "the '#{head}' symbol doesn't belong to propositional logic alphabet."
    end

    check(tail)
  end
end
