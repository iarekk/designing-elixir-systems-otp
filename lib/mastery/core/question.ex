defmodule Mastery.Core.Question do
  defstruct ~w[asked substitutions template]a

  @type t :: %__MODULE__{
          asked: String.t(),
          substitutions: map(),
          template: Mastery.Core.Template.t()
        }
end
