defmodule PropositionalLogicHelper do
  @moduledoc """
  Documentation for `PropositionalLogicHelper`.
  """

  @greetings ~s"
Welcome to the Propositional Logic Helper!

Use the symbols below to write the logical expression.

Propositional symbols: Character between A and Z, all uppercase.
0: false
1: true
Negation: !
Conjunction: &
Disjunction: |
Implication: |
Biconditional: =

Use parenthesis to define the precedence, if parenthesis isn't present, the evaluation order of connectives will be, from biggest to smallest:

!: 4
&: 3
|: 2
>: 1
=: 0
"

  use Application

  def start() do
    IO.puts(@greetings)

    expression = String.trim(IO.gets("Type the logical expression: "), "\n")

    IO.puts("")

    Lexer.analyze(String.split(expression, "", trim: true))

    Parser.verify(String.split(expression, "", trim: true))

    rpn_expression = Parser.generate_RPN(String.split(expression, "", trim: true))

    TruthTable.generate(expression, rpn_expression)
  end
end
