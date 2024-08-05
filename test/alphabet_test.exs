defmodule AlphabetTest do
  use ExUnit.Case
  doctest Alphabet

  test "get connective precedece value" do
    assert Alphabet.connective_precedence(:|) == 2
  end
end
