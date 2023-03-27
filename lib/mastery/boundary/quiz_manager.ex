defmodule Mastery.Boundary.QuizManager do
  alias Mastery.Core.Quiz
  use GenServer

  def init(quizzes) when is_map(quizzes) do
    {:ok, quizzes}
  end

  def init(_quizzes), do: {:error, "quizzes must be a map"}

  def handle_call({:build_quiz, quiz_fields}, _from, quizzes) do
    new_quiz = Quiz.new(quiz_fields)
    new_quizzes = Map.put(quizzes, new_quiz.title, new_quiz)
    {:reply, :ok, new_quizzes}
  end
end
