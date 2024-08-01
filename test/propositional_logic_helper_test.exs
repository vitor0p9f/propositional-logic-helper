defmodule PropositionalLogicHelperTest do
  use ExUnit.Case
  doctest PropositionalLogicHelper

  test "greets the world" do
    assert PropositionalLogicHelper.hello() == :world
  end
end
