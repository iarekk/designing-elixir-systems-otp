defmodule Mastery.Core.Question do
  alias Mastery.Core.Template
  defstruct ~w[asked substitutions template]a

  @type t :: %__MODULE__{
          asked: String.t(),
          substitutions: map(),
          template: Mastery.Core.Template.t()
        }

  def new(%Template{} = template) do
    subs =
      template.generators
      |> Enum.map(&build_substitution/1)

    subs |> evaluate(template)
  end

  def build_substitution({name, choices_of_generator}) do
    {name, choose(choices_of_generator)}
  end

  def choose(choices) when is_list(choices) do
    Enum.random(choices)
  end

  def choose(generator) when is_function(generator) do
    generator.()
  end

  defp compile(template, substitutions) do
    template.compiled |> Code.eval_quoted(assigns: substitutions) |> elem(0)
  end

  defp evaluate(substitutions, template) do
    %__MODULE__{
      asked: compile(template, substitutions),
      substitutions: substitutions,
      template: template
    }
  end
end

# These are the things a question needs to be able to do:
# • We need a constructor called new that will take a Template and generate a Question.
# • We need a function to build the substitutions to plug into our templates.
# • As we build substitutions, we’ll need to process two different kinds of generators,
#     a random choice from a list and a function that generates a substitution.
# • We need to process the substitutions for our template.
