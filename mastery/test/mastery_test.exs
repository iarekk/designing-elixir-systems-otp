defmodule MasteryTest do
  use ExUnit.Case, async: false
  use QuizBuilders
  alias MasteryPersistence.Repo
  alias Mastery.Examples.Math
  alias Mastery.Boundary.QuizSession
  alias MasteryPersistence.Response

  doctest Mastery

  setup do
    enable_persistence()

    always_add_1_to_2 = [
      template_fields(generators: addition_generators([1], [2]))
    ]

    assert "" !=
             ExUnit.CaptureLog.capture_log(fn ->
               :ok = start_quiz(always_add_1_to_2)
             end)

    :ok
  end

  test "Take a quiz, manage lifecycle and persist responses" do
    title = Keyword.fetch(Math.quiz_fields(), :title)
    session = take_quiz("yes_mathter@example.com")

    allow_session_to_write_to_db(self(), session)

    select_question(session)
    assert give_wrong_answer(session) == {"1 + 2", false}
    assert give_right_answer(session) == {"1 + 2", true}
    assert give_right_answer(session) == :finished
    assert response_count() == 3
    assert QuizSession.active_sessions_for(title) == []
  end

  defp enable_persistence() do
    :ok = Ecto.Adapters.SQL.Sandbox.checkout(Repo)
  end

  defp response_count() do
    Repo.aggregate(Response, :count, :id)
  end

  defp start_quiz(fields) do
    now = DateTime.utc_now()
    ending = DateTime.add(now, 60)
    Mastery.schedule_quiz(Math.quiz_fields(), fields, now, ending)
  end

  defp take_quiz(email) do
    Mastery.take_quiz(Math.quiz().title, email)
  end

  defp select_question(session) do
    assert Mastery.select_question(session) == "1 + 2"
  end

  defp give_wrong_answer(session) do
    Mastery.answer_question(
      session,
      "wrong",
      &MasteryPersistence.record_response/2
    )
  end

  defp give_right_answer(session) do
    Mastery.answer_question(
      session,
      "3",
      &MasteryPersistence.record_response/2
    )
  end

  defp allow_session_to_write_to_db(self_pid, session) do
    allow_pid = GenServer.whereis(QuizSession.via(session))
    Ecto.Adapters.SQL.Sandbox.allow(Repo, self_pid, allow_pid)
  end
end
