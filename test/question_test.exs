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

  test "test random generators" do
    generators = addition_generators(Enum.to_list(1..9), [0])

    assert eventually_match(generators, 1)
    assert eventually_match(generators, 9)
    # assert eventually_match(generators, 15) # this will fail
  end

  defp eventually_match(generators, expected_answer, depth \\ 1000)

  defp eventually_match(_, _, 0), do: false

  defp eventually_match(generators, expected_answer, depth) do
    subs = build_question(generators: generators).substitutions
    # IO.puts("subs: #{inspect(subs)}")
    left = Keyword.fetch!(subs, :left)
    # IO.puts("found left: #{inspect(left)} at depth #{depth}")

    left == expected_answer || eventually_match(generators, expected_answer, depth - 1)
  end
end
