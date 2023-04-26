defmodule ProctorTest do
  use ExUnit.Case
  alias Mastery.Boundary.Proctor

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
end
