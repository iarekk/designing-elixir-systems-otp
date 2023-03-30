defmodule Mastery.Boundary.QuizValidator do
  import Mastery.Boundary.Validator

  def errors(fields) when is_list(fields) do
    field_map = Map.new(fields)

    []
    |> required(field_map, :title, &validate_title/1)
    |> optional(field_map, :mastery, &validate_mastery/1)
  end

  def errors(_), do: [{nil, "A list of fields is required"}]

  def validate_title(title) when is_binary(title) do
    check(is_not_blank(title), {:error, "Can't be blank"})
  end

  def validate_title(_), do: {:error, "Must be a string"}

  def validate_mastery(mastery) when is_integer(mastery) do
    check(mastery >= 1, {:error, "Must be greater than 0"})
  end

  def validate_mastery(_), do: {:error, "Must be an integer"}
end
