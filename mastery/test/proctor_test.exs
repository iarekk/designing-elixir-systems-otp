defmodule ProctorTest do
  use ExUnit.Case
  alias Mastery.Examples.Math
  alias Mastery.Boundary.QuizSession
  alias Mastery.Boundary.Proctor

  # @moduletag capture_log: true

  doctest Mastery.Boundary.Proctor

  test "build reply with no timeout, empty list of quizzes" do
    reply = {:noreply}
    reply_with_timeout = Proctor.build_reply_with_timeout(reply, [], nil)

    assert reply_with_timeout == {:noreply, []}
  end

  test "build reply with no timeout, single quiz" do
    reply = {:noreply}
    now = DateTime.utc_now()
    quiz = %{start_at: DateTime.add(now, 10000, :millisecond)}
    reply_with_timeout = Proctor.build_reply_with_timeout(reply, [quiz], now)

    assert reply_with_timeout == {:noreply, [quiz], 10000}
  end

  test "quizzes can be scheduled" do
    title = "timed_addition"

    quiz =
      Math.quiz_fields()
      |> Keyword.put(:title, title)

    now = DateTime.utc_now()
    email = "student@example.com"

    refute Mastery.take_quiz(title, email)

    assert :ok ==
             Mastery.schedule_quiz(
               quiz,
               [Math.template_fields()],
               DateTime.add(now, 50, :millisecond),
               DateTime.add(now, 100, :millisecond),
               self()
             )

    assert_receive {:started, ^title}
    assert Mastery.take_quiz(title, email)
    assert_receive {:stopped, ^title}
    assert [] == QuizSession.active_sessions_for(title)
  end
end
