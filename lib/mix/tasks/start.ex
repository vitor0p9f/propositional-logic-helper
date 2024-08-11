defmodule Mix.Tasks.Start do
  use Mix.Task

  def run(_args) do
    PropositionalLogicHelper.start()
  end
end
