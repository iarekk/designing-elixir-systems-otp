defmodule QuizTest do
  use QuizBuilders
  use ExUnit.Case

  test "quiz switches templates" do
    quiz = Quiz.select_question(build_quiz_with_two_templates())
    templ = template(quiz)
    # tests whether we actually switch to a template
    assert eventually_selects_other_template(quiz, templ)
  end

  describe "when a quiz has two templates" do
    setup [:quiz]

    test "the next question is randomly selected", %{quiz: quiz} do
      %{current_question: %{template: first_template}} = Quiz.select_question(quiz)
      # fetches the first 'other' template, slightly differently from the test above
      other_template = eventually_pick_other_template(quiz, first_template)
      refute is_nil(other_template)
      assert first_template != other_template
    end

    test "templates are unique until cycle repeats", %{quiz: quiz} do
      first_quiz = Quiz.select_question(quiz)
      second_quiz = Quiz.select_question(first_quiz)
      reset_quiz = Quiz.select_question(second_quiz)
      assert template(first_quiz) != template(second_quiz)
      assert template(reset_quiz) in [template(first_quiz), template(second_quiz)]
      # IO.puts("First:  #{template(first_quiz).name}")
      # IO.puts("Second: #{template(second_quiz).name}")
      # IO.puts("Reset:  #{template(reset_quiz).name}")
      # First:  single_digit_addition
      # Second: double_digit_addition
      # Reset:  double_digit_addition
    end
  end

  defp eventually_selects_other_template(
         %Quiz{} = quiz,
         %Template{} = current_template,
         max_iterations \\ 10
       ) do
    Stream.repeatedly(fn ->
      Quiz.select_question(quiz) |> template()
    end)
    |> stream_limit(max_iterations)
    |> Enum.any?(fn template ->
      template != current_template
    end)
  end

  defp eventually_pick_other_template(
         %Quiz{} = quiz,
         %Template{} = current_template,
         max_iterations \\ 10
       ) do
    Stream.repeatedly(fn ->
      Quiz.select_question(quiz) |> template()
    end)
    |> stream_limit(max_iterations)
    |> Enum.find(fn template ->
      template != current_template
    end)
  end

  defp template(%Quiz{} = quiz), do: quiz.current_question.template

  defp right_answer(quiz), do: answer_question(quiz, "3")

  defp wrong_answer(quiz), do: answer_question(quiz, "wrong")

  defp answer_question(quiz, answer) do
    email = "mathy@example.com"
    response = Response.new(quiz, email, answer)
    Quiz.answer_question(quiz, response)
  end

  defp quiz(context) do
    {:ok, Map.put(context, :quiz, build_quiz_with_two_templates())}
  end

  defp quiz_always_adds_one_and_two(context) do
    fields = template_fields(generators: addition_generators([1], [2]))

    quiz =
      build_quiz(mastery: 2)
      |> Quiz.add_template(fields)

    {:ok, Map.put(context, :quiz, quiz)}
  end

  defp assert_more_questions(quiz) do
    refute is_nil(quiz)
    quiz
  end

  defp refute_more_questions(quiz) do
    assert is_nil(quiz)
    quiz
  end
end
