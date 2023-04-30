# iex --dot-iex lib/mastery/examples/proctor_run.exs -S mix

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
  one_minute_from_now
)

Mastery.schedule_quiz(
  Math.quiz_fast_fields(),
  [Math.template_fields()],
  twenty_seconds_from_now,
  one_minute_from_now
)

# :timer.sleep(1000)

Mastery.schedule_quiz(
  Math.quiz_fields(),
  [Math.template_fields()],
  five_seconds_from_now,
  one_minute_from_now
)

quiz_title = Keyword.fetch!(Math.quiz_fields(), :title)
# Mastery.take_quiz(quiz_title, "iarek@example.com")
# QuizSession.active_sessions_for(quiz_title)
