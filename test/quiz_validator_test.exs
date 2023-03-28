defmodule QuizValidatorTest do
  use ExUnit.Case
  alias Mastery.Boundary.QuizValidator
  alias Mastery.Core.Quiz

  test "verify quiz required fields" do
    quiz = %Quiz{}
    assert QuizValidator.errors(quiz) == [title: "Must be a string"]
  end

  test "verify regular map required fields" do
    quiz = Map.new()
    assert QuizValidator.errors(quiz) == [title: "Is required"]
  end
end
