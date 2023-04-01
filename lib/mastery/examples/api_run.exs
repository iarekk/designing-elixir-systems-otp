alias Mastery.Examples.Math
Mastery.start_quiz_manager()
Mastery.build_quiz(Math.quiz_fields())
Mastery.add_template(Math.quiz().title, Math.template_fields())

session = Mastery.take_quiz(Math.quiz().title, "mathy@email.com")
Mastery.select_question(session)

Mastery.answer_question(session, "wrong")
