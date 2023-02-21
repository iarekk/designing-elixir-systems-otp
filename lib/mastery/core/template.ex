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

  def new(fields) do
    IO.puts("Constructor called #{inspect(fields)}")
    raw = Keyword.fetch!(fields, :raw)

    struct!(
      __MODULE__,
      Keyword.put(fields, :compiled, EEx.compile_string(raw))
    )
  end
end
