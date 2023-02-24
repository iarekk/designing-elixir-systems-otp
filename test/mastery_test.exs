defmodule MasteryTest do
  use ExUnit.Case
  doctest Mastery

  test "greets the world" do
    assert Mastery.hello() == :world
  end

  test "can create a template" do
    temp1 = Mastery.Core.Template.new(name: :lol, raw: "<%= left %> + <%= right %>")
    assert temp1.name == :lol
    {result, _bindings} = Code.eval_quoted(temp1.compiled, left: 100, right: "hehe")
    assert result == "100 + hehe"
  end

  test "can create a question" do
    r = %Mastery.Core.Question{
      asked: "Hello?",
      substitutions: %{"1" => "2"}
    }

    assert getQ(r) == "Hello?"

    assert r.substitutions["1"] == "2"
  end

  test "quiz" do
    quiz = %Mastery.Core.Quiz{mastery: 5}
    assert quiz.mastery == 5
  end

  test "pass BS" do
    q = getQ(%Mastery.Core.Question{asked: 5})
    assert q == 5
  end

  @spec getQ(Mastery.Core.Question.t()) :: String.t()
  def getQ(%Mastery.Core.Question{asked: q}) do
    q
  end
end
