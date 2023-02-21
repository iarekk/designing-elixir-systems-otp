defmodule Mastery.Core.Response do
  defstruct ~w[quiz_title template_name to email answer correct timestamp]a

  @type t :: %__MODULE__{
          quiz_title: String.t(),
          template_name: atom(),
          to: String.t(),
          email: String.t(),
          answer: String.t(),
          correct: boolean(),
          timestamp: Time.t()
        }

  @spec new(
          Mastery.Core.Quiz.t(),
          String.t(),
          String.t()
        ) :: Mastery.Core.Response.t()
  def new(quiz, email, answer) do
    question = quiz.current_question
    template = question.template

    %__MODULE__{
      quiz_title: quiz.title,
      template_name: template.name,
      to: question.asked,
      email: email,
      answer: answer,
      correct: template.checker.(question.substitutions, answer),
      timestamp: DateTime.utc_now()
    }
  end
end
