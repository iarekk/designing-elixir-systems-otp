defmodule QuizTest do
  use QuizBuilders
  use ExUnit.Case

  test "quiz switches templates" do
    quiz = Quiz.select_question(build_quiz_with_two_templates())
    templ = template(quiz)
    assert eventually_picks_other_template(quiz, templ)
  end

  defp eventually_picks_other_template(
         %Quiz{} = quiz,
         %Template{} = current_template,
         max_iterations \\ 10
       ) do
    Stream.repeatedly(fn ->
      Quiz.select_question(quiz) |> template()
    end)
    |> Stream.with_index()
    |> Stream.take_while(fn {_template, index} -> index < max_iterations end)
    |> Stream.map(fn {el, _index} -> el end)
    |> Enum.find(
      false,
      fn template ->
        template != current_template
      end
    )
  end

  defp template(%Quiz{} = quiz), do: quiz.current_question.template
end
