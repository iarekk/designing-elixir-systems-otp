defmodule QuizValidatorTest do
  use ExUnit.Case
  alias Mastery.Boundary.QuizValidator

  test "verify quiz checks title type" do
    quiz = [title: :lol]
    assert QuizValidator.errors(quiz) == [title: "Must be a string"]
  end

  test "verify quiz required fields accepts correct values" do
    quiz = [title: "lol", mastery: 3]
    assert QuizValidator.errors(quiz) == []
  end

  test "verify quiz checks mastery type" do
    quiz = [title: "lol", mastery: :it_is_grand]
    assert QuizValidator.errors(quiz) == [mastery: "Must be an integer"]
  end

  test "verify quiz title is required" do
    quiz = []
    assert QuizValidator.errors(quiz) == [title: "Is required"]
  end
end
