defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  describe "wrong syntax" do
    test "two or more propositional symbols in sequence" do
      assert_raise WrongSyntaxError, fn -> Parser.verify(["A", "A", "&", "B"]) end
    end
  end
end
