defmodule Evaluator do
  @moduledoc """
  Evaluate propositional logic expressions
  """

  @doc """
  Evaluate a propositional logic expression expressed in Reverse Polish Notation(RPN).

  Returns the RPN expression value.

  ## Example

      iex> Evaluator.evaluate(["A", "B", ">", "0", "D", "|", "1", "=", "&"], %{"A" => true, "B" => false, "D" => true, "0" => false})
      false

      iex> Evaluator.evaluate(["A", "B", "!", "&", "B", "!", "|", "A", "="], %{"A" => false, "B" => true})
      true
  """
  @spec evaluate(list(String.t()), map()) :: boolean()
  def evaluate(list, map) when is_list(list) and is_map(map), do: evaluate_aux(list, map, [])

  defp evaluate_aux([], _, [result]), do: result

  defp evaluate_aux([head | tail], map, stack) do
    cond do
      String.match?(head, Alphabet.connectives()) ->
        cond do
          Alphabet.symbol_type(head) == :negation ->
            {right_operator, updated_stack} = List.pop_at(stack, 0)

            evaluate_aux(tail, map, [!right_operator | updated_stack])

          true ->
            {right_operator, updated_stack} = List.pop_at(stack, 0)
            {left_operator, new_stack} = List.pop_at(updated_stack, 0)

            cond do
              Alphabet.symbol_type(head) == :conjunction ->
                evaluate_aux(tail, map, [left_operator and right_operator | new_stack])

              Alphabet.symbol_type(head) == :disjunction ->
                evaluate_aux(tail, map, [left_operator or right_operator | new_stack])

              Alphabet.symbol_type(head) == :implication ->
                evaluate_aux(tail, map, [
                  implication(left_operator, right_operator) | new_stack
                ])

              true ->
                evaluate_aux(tail, map, [
                  biconditional(left_operator, right_operator) | new_stack
                ])
            end
        end

      true ->
        evaluate_aux(tail, map, [map[head] | stack])
    end
  end

  defp implication(left_operand, right_operand) do
    cond do
      left_operand == true and right_operand == false -> false
      true -> true
    end
  end

  defp biconditional(left_operand, right_operand) do
    cond do
      left_operand == right_operand -> true
      true -> false
    end
  end
end
