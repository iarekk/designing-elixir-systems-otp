alias Mastery.Examples.Math
alias Mastery.Boundary.QuizManager
{:ok, _pid} = GenServer.start_link(QuizManager, %{}, name: QuizManager)
:ok = QuizManager.build_quiz(title: "quiz")
IO.puts("Empty quiz:")
QuizManager.lookup_quiz_by_title("quiz") |> IO.inspect()
:ok = QuizManager.add_template("quiz", Math.template_fields())
IO.puts("Quiz with added template:")
QuizManager.lookup_quiz_by_title("quiz") |> IO.inspect()
