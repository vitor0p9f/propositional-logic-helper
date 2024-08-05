defmodule LexerTest do
  use ExUnit.Case
  doctest Lexer

  test "raise an error when an invalid character is found" do
    assert_raise UnexpectedCharacterError,
                 "the '$' symbol doesn't belong to propositional logic alphabet.",
                 fn ->
                   Lexer.analyze(["|", "A", "$"])
                 end
  end
end
