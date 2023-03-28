defmodule Mastery.Boundary.QuizSession do
  alias Mastery.Core.{Quiz, Response}
  use GenServer

  def select_question(session) do
    GenServer.call(session, :select_question)
  end

  def answer_question(session, answer) do
    GenServer.call(session, {:answer_question, answer})
  end

  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  def handle_call(:select_question, _from, {quiz, email}) do
    new_quiz = Quiz.select_question(quiz)
    {:reply, new_quiz.current_question.asked, {new_quiz, email}}
  end

  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    resp = Response.new(quiz, email, answer)

    quiz
    |> Quiz.answer_question(resp)
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  def maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  def maybe_finish(quiz, email) do
    {:reply, {quiz.current_question.asked, quiz.last_response.correct}, {quiz, email}}
  end
end

# iex(2)> {:ok, session} = GenServer.start_link(Mastery.Boundary.QuizSession, {Mastery.Examples.Math.quiz(), "mathy@example.com"})
# {:ok, #PID<0.272.0>}
# iex(3)> Mastery.Boundary.QuizSession.select_question se
# self/0     send/2     session
# iex(3)> Mastery.Boundary.QuizSession.select_question session
# "0 + 7"
# iex(4)> Mastery.Boundary.QuizSession.answer_question session, "7"
# {"4 + 7", true}
# iex(5)> Mastery.Boundary.QuizSession.answer_question session, "11"
# :finished
