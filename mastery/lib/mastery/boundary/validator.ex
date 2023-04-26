defmodule Mastery.Boundary.Validator do
  def required(errors, fields, field_name, validator) do
    present = Map.has_key?(fields, field_name)
    # IO.puts("Map has key: #{present}, #{inspect(fields)}, #{inspect(field_name)}")
    check_required_field(present, fields, errors, field_name, validator)
  end

  def optional(errors, fields, field_name, validator) do
    present = Map.has_key?(fields, field_name)

    if(present) do
      required(errors, fields, field_name, validator)
    else
      errors
    end
  end

  def check(true = _valid, _message), do: :ok
  def check(_valid, message), do: message

  def check_required_field(true = _present, fields, errors, field_name, validator) do
    # IO.inspect("check_required_field called with true for #{field_name}")
    valid = fields |> Map.fetch!(field_name) |> validator.()
    check_field(valid, errors, field_name)
  end

  def check_required_field(_present, _fields, errors, field_name, _validator) do
    # IO.inspect("check_required_field called with FALSE for #{field_name}")
    errors ++ [{field_name, "Is required"}]
  end

  # TODO this is suspect, shoudln't we return [errors] instead?
  # Original book code:
  # def check_field(:ok, _errors, _field_name), do: :ok
  def check_field(:ok, errors, _field_name), do: errors

  def check_field({:error, message}, errors, field_name) do
    errors ++ [{field_name, message}]
  end

  def check_field({:errors, messages}, errors, field_name) do
    errors ++ Enum.map(messages, &{field_name, &1})
  end

  def is_not_blank(str) when is_binary(str), do: String.trim(str) != ""
  def is_not_blank(_), do: false
end
