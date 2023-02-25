defmodule Mastery.Core.Quiz do
  alias Mastery.Core.Quiz

  defstruct title: nil,
            mastery: 3,
            templates: %{},
            used: [],
            current_question: nil,
            last_response: nil,
            record: %{},
            mastered: []

  def new(fields) do
    struct!(__MODULE__, fields)
  end

  def add_template(quiz, fields) do
    template = new(fields)

    templates = update_in(quiz.templates, [template.category], &add_to_list_or_nil(&1, template))

    %Quiz{quiz | templates: templates}
  end

  def add_to_list_or_nil(nil, x), do: [x]
  def add_to_list_or_nil(xs, x), do: [x | xs]
end

# title (String.t)                                The title for a quiz.
# mastery (integer)                               The number of questions a user must get right to master a quiz category.
#
# metadata as users advance through the quiz:
#
# current_question (Question.t)                   The current question being presented to the user.
# last_response (Response.t)                      The last response given by the user.
# templates (%{ "category" => [Template.t]})      The master list of templates, by category.
# used ([Template.t])                             The templates that we’ve used, this cycle, that have not yet been mastered.
# mastered ([Template.t])                         The templates that have been mastered.
# record (%{ "template_name" => integer})         The number of correct answers in a row a user has given for each template.
