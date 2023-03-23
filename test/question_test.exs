defmodule QuestionTest do
  use QuizBuilders
  use ExUnit.Case

  test "building chooses substitutions" do
    question = build_question(generators: addition_generators([1], [2]))

    assert question.substitutions == [left: 1, right: 2]
  end

  test "function generators are called on the left" do
    megavalue = 42
    question = build_question(generators: addition_generators(fn -> megavalue end, [0]))

    assert Keyword.get(question.substitutions, :left) == megavalue
  end

  test "function generators are called on the right" do
    megavalue = 42
    question = build_question(generators: addition_generators([0], fn -> megavalue end))

    assert Keyword.get(question.substitutions, :right) == megavalue
  end

  test "test what's asked" do
    question = build_question(generators: addition_generators([1], [2]))

    assert question.asked == "1 + 2"
  end
end
