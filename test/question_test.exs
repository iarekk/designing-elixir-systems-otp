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
    refute eventually_match(generators, 15)
  end

  defp eventually_match(generators, expected_answer, max_iterations \\ 1000) do
    Stream.repeatedly(fn ->
      build_question(generators: generators).substitutions
    end)
    |> stream_limit(max_iterations)
    |> Enum.find(
      false,
      fn subs ->
        Keyword.fetch!(subs, :left) == expected_answer
      end
    )
  end

  # Version in the book, it doesn't terminate on values out of bounds:
  # def eventually_match(generators, answer) do
  #   Stream.repeatedly(fn ->
  #     build_question(generators: generators).substitutions
  #   end)
  #   |> Enum.find(fn substitution -> Keyword.fetch!(substitution, :left) == answer end)
  # end
end
