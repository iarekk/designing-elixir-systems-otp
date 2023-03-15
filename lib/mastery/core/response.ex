defmodule Mastery.Core.Response do
  alias Mastery.Core.Quiz
  defstruct ~w[quiz_title template_name to email answer correct timestamp]a

  @type t :: %__MODULE__{
          quiz_title: String.t(),
          template_name: atom(),
          to: String.t(),
          email: String.t(),
          answer: String.t(),
          correct: boolean(),
          timestamp: DateTime.t()
        }

  @spec new(Mastery.Core.Quiz.t(), any, any) :: Mastery.Core.Response.t()
  def new(%Quiz{} = quiz, email, answer) do
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
