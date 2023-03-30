defmodule Mastery.Boundary.TemplateValidator do
  import Mastery.Boundary.Validator

  def errors(fields) when is_list(fields) do
    # why is template taking a
    fields = Map.new(fields)

    []
    |> required(fields, :name, &validate_name/1)
    |> required(fields, :category, &validate_name/1)
    |> optional(fields, :instructions, &validate_instructions/1)
    |> required(fields, :raw, &validate_raw/1)
    |> required(fields, :generators, &validate_generators/1)
    |> required(fields, :checker, &validate_checker/1)
  end

  def errors(_fields), do: [{nil, "A keyword list of fields is required"}]

  def validate_name(name) when is_atom(name), do: :ok
  def validate_name(_), do: {:error, "Must be an atom"}
  def validate_instructions(instructions) when is_binary(instructions), do: :ok
  def validate_instructions(_), do: {:error, "Must be a binary"}

  def validate_raw(raw) when is_binary(raw) do
    check(is_not_blank(raw), {:error, "Can't be blank"})
  end

  def validate_raw(_raw), do: {:error, "Must be a string"}

  def validate_generators(generators) when is_map(generators) do
    generators
    |> Enum.map(&validate_generator/1)
    |> Enum.reject(&(&1 == :ok))
    |> case do
      [] -> :ok
      errors -> {:errors, errors}
    end
  end

  def validate_generators(_), do: {:error, "must be a map"}

  def validate_generator({name, generator})
      when is_atom(name) and is_list(generator) do
    check(generator != [], {:error, "List generator can't be empty"})
  end

  def validate_generator({name, generator})
      when is_atom(name) and is_function(generator, 0),
      do: :ok

  def validate_generator(_), do: {:error, "Must be an atom to list or function pair"}

  def validate_checker(checker) when is_function(checker, 2), do: :ok
  def validate_checker(_), do: {:error, "Must be an arity 2 function"}
end
