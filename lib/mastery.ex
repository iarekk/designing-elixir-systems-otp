defmodule Mastery do
  alias Mastery.Boundary.{QuizSession, QuizManager, Proctor}
  alias Mastery.Boundary.{TemplateValidator, QuizValidator}
  alias Mastery.Core.Quiz

  def build_quiz(fields) do
    # checking for empty list of errors, instead of :ok like in the book
    with [] <- QuizValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:build_quiz, fields}),
         do: :ok,
         else: (error -> error)
  end

  def add_template(title, fields) do
    # checking for empty list of errors, instead of :ok like in the book
    with [] <- TemplateValidator.errors(fields),
         :ok <- GenServer.call(QuizManager, {:add_template, title, fields}),
         do: :ok,
         else: (error -> error)
  end

  def take_quiz(title, email) do
    with %Quiz{} = quiz <- QuizManager.lookup_quiz_by_title(title),
         {:ok, _} <- QuizSession.take_quiz(quiz, email),
         do: {title, email},
         else: (error -> error)
  end

  def select_question({_title, _email} = name) do
    GenServer.call(QuizSession.via(name), :select_question)
  end

  def answer_question({_title, _email} = name, answer) do
    GenServer.call(QuizSession.via(name), {:answer_question, answer})
  end

  def schedule_quiz(quiz, templates, start_at, end_at) do
    with [] <- QuizValidator.errors(quiz),
         true <- Enum.all?(templates, &([] == TemplateValidator.errors(&1))),
         :ok <- Proctor.schedule_quiz(quiz, templates, start_at, end_at),
         do: :ok,
         else: (error -> error)
  end
end
