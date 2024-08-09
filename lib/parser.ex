defmodule Parser do
  @moduledoc """
  Syntax verification of propositional logic.
  """

  @next_allowed_symbols %{
    propositional_and_truthy: [:close, :conjunction, :disjunction, :implication, :biconditional],
    close: [:close, :conjunction, :disjunction, :implication, :biconditional],
    open: [:propositional, :truthy, :open, :negation],
    negation: [:propositional, :truthy, :open, :negation],
    other_connectives: [:propositional, :truthy, :open]
  }

  @doc """
  Verify the syntax of an expression belonging to propositional logic.

  Returns `:ok` when the syntax is right.

  Raise `SyntaxError` when encountering a syntax error.

  ## Example

      iex> Parser.verify([])
      :ok

      iex> Parser.verify(["!","!","A"])
      :ok

      iex> Parser.verify(["!","&","A"])
      ** (SyntaxError) the '&' symbol cannot be after the '!' symbol.
  """
  @spec verify(list(String.t())) :: :ok
  def verify([]), do: :ok

  def verify([symbol]) do
    unless String.match?(symbol, Alphabet.propositional_symbols()) or
             String.match?(symbol, Alphabet.truthy_symbols()) or
             Alphabet.symbol_type(symbol) == :close do
      raise SyntaxError,
        message: "connectives or punctuation cannot be considered true or false."
    end

    :ok
  end

  def verify(list = [head, second | tail]) when is_list(list) do
    allowed_symbols =
      cond do
        String.match?(head, Alphabet.propositional_symbols()) or
            String.match?(head, Alphabet.truthy_symbols()) ->
          @next_allowed_symbols[:propositional_and_truthy]

        String.match?(head, Alphabet.punctuation()) and head == "(" ->
          @next_allowed_symbols[:open]

        String.match?(head, Alphabet.punctuation()) and head == ")" ->
          @next_allowed_symbols[:close]

        String.match?(head, Alphabet.connectives()) and head == "!" ->
          @next_allowed_symbols[:negation]

        String.match?(head, Alphabet.connectives()) and head != "!" ->
          @next_allowed_symbols[:other_connectives]
      end

    check_symbol(allowed_symbols, head, second)

    verify([second | tail])
  end

  defp check_symbol(allowed_symbols, previous_symbol, symbol) do
    unless Enum.member?(allowed_symbols, Alphabet.symbol_type(symbol)) do
      raise SyntaxError,
        message: "the '#{symbol}' symbol cannot be after the '#{previous_symbol}' symbol."
    end
  end

  @doc """
  Generate a Reverse Polish Notation(RPN) from an expression.

  Returns a list with the expression in the RPN form.

  ## Example

      iex> Parser.generate_RPN(["A","|","B"])
      ["A","B","|"]

      iex> Parser.generate_RPN(["(","A","&","B",")","|","C"])
      ["A","B","&","C","|"]

      iex> Parser.generate_RPN(["(","(","A","&","B",")","|","C",")","=","D"])
      ["A","B","&","C","|","D","="]
  """
  @spec generate_RPN(list(String.t())) :: list(String.t())
  def generate_RPN(list) when is_list(list),
    do: String.split(expression_generator(list, [], ""), "", trim: true)

  defp expression_generator([], [], expression), do: expression

  defp expression_generator([], stack, expression), do: expression <> Enum.join(stack)

  defp expression_generator(
         [list_head | list_tail],
         stack,
         expression
       ) do
    cond do
      String.match?(list_head, Alphabet.propositional_symbols()) or
          String.match?(list_head, Alphabet.truthy_symbols()) ->
        expression_generator(list_tail, stack, expression <> list_head)

      String.match?(list_head, Alphabet.punctuation()) and list_head == "(" ->
        expression_generator(list_tail, [list_head | stack], expression)

      String.match?(list_head, Alphabet.punctuation()) and list_head == ")" ->
        {updated_expression, updated_stack} =
          append_from_stack_to_expression(stack, expression, fn item ->
            item != "("
          end)

        expression_generator(list_tail, updated_stack, updated_expression)

      String.match?(list_head, Alphabet.connectives()) ->
        if Enum.empty?(stack) do
          expression_generator(list_tail, [list_head | stack], expression)
        else
          {updated_expression, updated_stack} =
            append_from_stack_to_expression(stack, expression, fn symbol ->
              String.match?(symbol, Alphabet.connectives()) and
                Alphabet.connective_precedence(String.to_atom(symbol)) <=
                  Alphabet.connective_precedence(String.to_atom(list_head))
            end)

          expression_generator(
            list_tail,
            [list_head | List.delete(updated_stack, "(")],
            updated_expression
          )
        end
    end
  end

  defp append_from_stack_to_expression([], expression, _), do: {expression, []}

  defp append_from_stack_to_expression(stack = [head | tail], expression, condition) do
    if condition.(head) do
      append_from_stack_to_expression(tail, expression <> head, condition)
    else
      {expression, stack}
    end
  end
end
