defmodule AlphabetTest do
  use ExUnit.Case
  doctest Alphabet

  test "the connective_precedece function" do
    answers = [{:!, 4}, {:&, 3}, {:|, 2}, {:>, 1}, {:=, 0}]

    Enum.each(answers, fn {connective, precedence} ->
      assert Alphabet.connective_precedence(connective) == precedence
    end)
  end

  test "the symbol_type function" do
    answers = [
      {"A", :propositional},
      {"0", :truthy},
      {"1", :truthy},
      {"(", :open},
      {")", :close},
      {"!", :negation},
      {"&", :conjunction},
      {"|", :disjunction},
      {">", :implication},
      {"=", :biconditional}
    ]

    Enum.each(answers, fn {symbol, type} ->
      assert Alphabet.symbol_type(symbol) == type
    end)
  end
end
