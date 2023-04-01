# cool hack: run the command below from the project root:
# iex --dot-iex lib/mastery/examples/api_run.exs -S mix
# it will:
# start iex
# load the project using mix
# execute the script below
#

alias Mastery.Examples.Math
Mastery.start_quiz_manager()
Mastery.build_quiz(Math.quiz_fields())
Mastery.add_template(Math.quiz().title, Math.template_fields())

session = Mastery.take_quiz(Math.quiz().title, "mathy@email.com")
Mastery.select_question(session) |> IO.puts()
IO.puts("Type `Mastery.answer_question session, \"4\"` to answer the question")
# Mastery.answer_question(session, "wrong")
