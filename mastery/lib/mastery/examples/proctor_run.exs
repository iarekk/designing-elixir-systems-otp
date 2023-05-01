# iex --dot-iex lib/mastery/examples/proctor_run.exs -S mix

defmodule ProctorRun do
  def receive_loop(0), do: IO.puts("done listening")

  def receive_loop(count) do
    rem = count - 1

    receive do
      {:started, title} ->
        IO.puts("Quiz started: #{title}, waiting for #{rem} further messages")
        receive_loop(rem)

      {:stopped, title} ->
        IO.puts("Quiz stopped: #{title}, waiting for #{rem} further messages")
        receive_loop(rem)

      msg ->
        raise("Unexpected message: #{inspect(msg)}")
    end
  end
end

alias Mastery.Examples.Math
alias Mastery.Boundary.QuizSession
now = DateTime.utc_now()
five_seconds_from_now = DateTime.add(now, 5)
twenty_seconds_from_now = DateTime.add(now, 20)
ten_seconds_from_now = DateTime.add(now, 10)
one_minute_from_now = DateTime.add(now, 60)

# :timer.sleep(1000)

Mastery.schedule_quiz(
  Math.quiz_medium_fields(),
  [Math.template_fields()],
  ten_seconds_from_now,
  one_minute_from_now,
  self()
)

Mastery.schedule_quiz(
  Math.quiz_fast_fields(),
  [Math.template_fields()],
  twenty_seconds_from_now,
  one_minute_from_now,
  self()
)

# :timer.sleep(1000)

Mastery.schedule_quiz(
  Math.quiz_fields(),
  [Math.template_fields()],
  five_seconds_from_now,
  one_minute_from_now,
  self()
)

quiz_title = Keyword.fetch!(Math.quiz_fields(), :title)

ProctorRun.receive_loop(6)

# Mastery.take_quiz(quiz_title, "iarek@example.com")
# QuizSession.active_sessions_for(quiz_title)
