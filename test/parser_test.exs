defmodule ParserTest do
  use ExUnit.Case
  doctest Parser

  describe "'SyntaxError' is raised" do
    test "when two or more propositional symbols, truthy symbols, or connectives, except negation, are in sequence" do
      cases = [["A", "A", "&", "B"], ["!", "0", "1"], ["A", "&", "=", "B"]]

      Enum.each(cases, fn case ->
        assert_raise SyntaxError, fn -> Parser.verify(case) end
      end)
    end

    test "when the logic expression has one element, and it isn't a propositional or truthy symbol" do
      cases = [["("], [")"], ["!"], ["&"], ["|"], [">"], ["="]]

      Enum.each(cases, fn case ->
        assert_raise SyntaxError, fn -> Parser.verify(case) end
      end)
    end
  end
end
