defmodule EvaluatorTest do
  use ExUnit.Case
  doctest Evaluator

  test "evaluates a propositional logic expression" do
    assert Evaluator.evaluate(["A", "B", "|"], %{"A" => true, "B" => false}) == true
  end
end
