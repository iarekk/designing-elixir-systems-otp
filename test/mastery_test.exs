defmodule MasteryTest do
  use ExUnit.Case
  doctest Mastery

  test "greets the world" do
    assert Mastery.hello() == :world
  end

  test "can create a question" do
    r = %Mastery.Core.Question{
      asked: "Hello?",
      substitutions: %{"1" => "2"}
    }

    assert r.asked == "Hello?"

    assert r.substitutions["1"] == "2"
  end
end
