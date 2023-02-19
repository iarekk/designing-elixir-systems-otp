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
end
