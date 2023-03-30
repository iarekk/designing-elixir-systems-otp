defmodule TemplateValidatorTest do
  use QuizBuilders
  use ExUnit.Case
  alias Mastery.Boundary.TemplateValidator

  describe "test templates pass the validator" do
    setup [:single_digits, :double_digits, :bad_checker]

    test "default test template passes validation", context do
      assert TemplateValidator.errors(context[:single_digits]) == []
      assert TemplateValidator.errors(context[:double_digits]) == []

      assert TemplateValidator.errors(context[:bad_checker]) == [
               {:checker, "Must be an arity 2 function"}
             ]

      assert TemplateValidator.errors([]) == [
               {:name, "Is required"},
               {:category, "Is required"},
               {:raw, "Is required"},
               {:generators, "Is required"},
               {:checker, "Is required"}
             ]
    end
  end

  defp single_digits(context) do
    Map.put(context, :single_digits, template_fields())
  end

  defp double_digits(context) do
    Map.put(context, :double_digits, double_digit_addition_template_fields())
  end

  defp bad_checker(context) do
    Map.put(context, :bad_checker, template_fields(checker: fn _ -> :ok end))
  end
end
