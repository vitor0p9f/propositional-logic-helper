defmodule AlphabetTest do
  use ExUnit.Case
  doctest Alphabet

  test "connective precedece function" do
    answers = [{:!, 4}, {:&, 3}, {:|, 2}, {:>, 1}, {:=, 0}]

    Enum.each(answers, fn {connective, precedence} ->
      assert Alphabet.connective_precedence(connective) == precedence
    end)
  end
  end
end
