# cool hack: run the command below from the project root:
# iex --dot-iex lib/mastery/examples/api_run.exs -S mix
# it will:
# start iex
# load the project using mix
# execute the script below
# idea taken from here: <https://itnext.io/a-collection-of-tips-for-elixirs-interactive-shell-iex-bff5e177405b>

alias Mastery.Examples.Math

IO.puts("Supervision tree")
Supervisor.which_children(Mastery.Supervisor) |> IO.inspect()
IO.puts("------------------------------")

Mastery.build_quiz(Math.quiz_fields())

quiz_title = Math.quiz().title
email = "mathy@email.com"
user = {quiz_title, email}

Mastery.add_template(quiz_title, Math.template_fields())

IO.puts("Registry before take_quiz call")
Registry.lookup(Mastery.Registry.QuizSession, user) |> IO.inspect()

^user = Mastery.take_quiz(quiz_title, email)

IO.puts("Registry after take_quiz call")
Registry.lookup(Mastery.Registry.QuizSession, user) |> IO.inspect()

Mastery.select_question({quiz_title, email}) |> IO.inspect()

IO.puts("Type `Mastery.answer_question user, \"4\"` to answer the question")

:observer.start()

# Mastery.answer_question(session, "wrong")
