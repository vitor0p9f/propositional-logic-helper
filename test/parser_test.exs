defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  describe "'SyntaxError' is raised" do
    test "when two or more propositional symbols are in sequence" do
      assert_raise SyntaxError, fn -> Parser.verify(["A", "A", "&", "B"]) end
    end
  end
end
