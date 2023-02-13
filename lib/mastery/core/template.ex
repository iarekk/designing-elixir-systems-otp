defmodule Mastery.Core.Template do
  defstruct ~w[name category instructions raw compiled generators checker]a

  @type t :: %__MODULE__{
          name: atom,
          category: atom,
          instructions: String.t(),
          raw: String.t(),
          compiled: Macro,
          generators: map(),
          checker: fun()
        }
end
