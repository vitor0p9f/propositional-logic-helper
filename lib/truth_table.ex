defmodule TruthTable do
  @moduledoc """
  Handles with the generation of the truth table
  """

  def generate(expression, rpn_expression) when is_list(rpn_expression) do
    {symbols, symbols_values, number_of_rows} = generate_symbols_values(rpn_expression)

    table = []
    table = table ++ [generate_top_line(symbols, expression)]
    table = table ++ [generate_header(symbols, expression)]
    table = table ++ [generate_middle_line(symbols, expression)]

    table =
      table ++
        Enum.reduce(Enum.to_list(1..number_of_rows), [], fn row, acc ->
          acc = acc ++ [generate_line(row, symbols, symbols_values, rpn_expression, expression)]

          if row != number_of_rows do
            acc ++ [generate_middle_line(symbols, expression)]
          else
            acc
          end
        end)

    table = table ++ [generate_bottom_line(symbols, expression)]

    results =
      Enum.reduce(Enum.to_list(1..number_of_rows), [], fn row, acc ->
        new_symbols_values =
          Enum.into(symbols_values, %{}, fn {key, value} ->
            if key == "0" or key == "1" do
              {key, value}
            else
              {key, Enum.at(value, row - 1)}
            end
          end)

        acc ++ [Evaluator.evaluate(rpn_expression, new_symbols_values)]
      end)

    print(table)

    properties = get_expression_properties(results)

    IO.puts("\nThe proposition #{expression} has the following characteristics:\n")

    Enum.each(properties, fn property -> IO.puts("It's #{property}.") end)
  end

  defp print([row]), do: IO.puts(row)

  defp print([row | rest]) do
    IO.puts(row)

    print(rest)
  end

  defp generate_symbols_values(rpn_expression) when is_list(rpn_expression) do
    propositonal_symbols =
      Enum.filter(rpn_expression, fn symbol ->
        String.match?(symbol, Alphabet.propositional_symbols())
      end)
      |> Enum.uniq()

    number_of_rows = Integer.pow(2, Enum.count(propositonal_symbols))

    values =
      for symbol <- propositonal_symbols, into: %{} do
        symbol_position = Enum.find_index(propositonal_symbols, fn item -> item == symbol end)

        {symbol, compute_value(1, number_of_rows, symbol_position, false, [])}
      end

    {propositonal_symbols, Map.merge(values, %{"0" => false, "1" => true}), number_of_rows}
  end

  defp compute_value(current_row, number_of_rows, symbol_position, switch, values) do
    cond do
      current_row == number_of_rows ->
        values ++ [false]

      rem(current_row, div(number_of_rows, Integer.pow(2, symbol_position + 1))) == 0 ->
        compute_value(
          current_row + 1,
          number_of_rows,
          symbol_position,
          !switch,
          values ++ [!switch]
        )

      switch ->
        compute_value(current_row + 1, number_of_rows, symbol_position, switch, values ++ [false])

      true ->
        compute_value(current_row + 1, number_of_rows, symbol_position, switch, values ++ [true])
    end
  end

  defp generate_top_line(symbols, expression) do
    row =
      Enum.reduce(symbols, "", fn symbol, acc ->
        if symbol == hd(symbols) do
          acc <> "┌───┬"
        else
          acc <>
            "───┬"
        end
      end)

    row <>
      "─" <>
      String.duplicate("─", String.length(expression)) <>
      "─┐"
  end

  defp generate_middle_line(symbols, expression) do
    row =
      Enum.reduce(symbols, "", fn symbol, acc ->
        if symbol == hd(symbols) do
          acc <> "├───┼"
        else
          acc <> "───┼"
        end
      end)

    row <>
      "─" <>
      String.duplicate("─", String.length(expression)) <>
      "─┤"
  end

  defp generate_header(symbols, expression) do
    row =
      Enum.reduce(symbols, "", fn symbol, acc ->
        if symbol == hd(symbols) do
          acc <> "│ #{symbol} │"
        else
          acc <> " #{symbol} │"
        end
      end)

    row <> " #{expression} │"
  end

  defp generate_line(current_row, symbols, symbols_values, rpn_expression, expression) do
    row =
      Enum.reduce(symbols, "", fn symbol, acc ->
        if symbol == hd(symbols) do
          if Enum.at(symbols_values[symbol], current_row - 1) do
            acc <> "│ T │" 
          else
            acc <> "│ F │" 
          end
        else
          if Enum.at(symbols_values[symbol], current_row - 1) do
            acc <> " T │" 
          else
            acc <> " F │" 
          end
        end
      end)

    new_symbols_values =
      Enum.into(symbols_values, %{}, fn {key, value} ->
        if key == "0" or key == "1" do
          {key, value}
        else
          {key, Enum.at(value, current_row - 1)}
        end
      end)

    result =
      if Evaluator.evaluate(rpn_expression, new_symbols_values) do
        "T"
      else
        "F"
      end

    if rem(String.length(expression), 2) == 0 do
      row <>
        String.duplicate(" ", div(String.length(expression) + 2, 2) - 1) <>
        "#{result}" <>
        String.duplicate(" ", div(String.length(expression) + 2, 2)) <>
        "│"
    else
      row <>
        String.duplicate(" ", div(String.length(expression) + 2, 2)) <>
        "#{result}" <>
        String.duplicate(" ", div(String.length(expression) + 2, 2)) <>
        "│"
    end
  end

  defp generate_bottom_line(symbols, expression) do
    row =
      Enum.reduce(symbols, "", fn symbol, acc ->
        if symbol == hd(symbols) do
          acc <> "└───┴"
        else
          acc <> "───┴"
        end
      end)

    row <>
      "─" <>
      String.duplicate("─", String.length(expression)) <>
      "─┘"
  end

  defp get_expression_properties(results) do
    answers = []

    cond do
      Enum.all?(results) ->
        List.flatten([["a tautology", "satisfiable"] | answers])

      Enum.any?(results) ->
        ["satisfiable" | answers]

      true ->
        ["a contradiction" | answers]
    end
  end
end
