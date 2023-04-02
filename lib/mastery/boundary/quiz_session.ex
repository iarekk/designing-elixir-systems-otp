defmodule Mastery.Boundary.QuizSession do
  alias Mastery.Core.{Quiz, Response}
  use GenServer

  def child_spec({%Quiz{title: title} = quiz, email}) do
    # IO.puts("child_spec invoked: #{inspect({title, email})}")

    %{
      # unique process identifier for the supervisors
      id: {__MODULE__, {title, email}},
      # all the info needed to start this process
      start: {__MODULE__, :start_link, [{quiz, email}]},
      restart: :temporary
    }
  end

  def start_link({%Quiz{title: title} = quiz, email}) do
    # IO.puts("QuizSession.start_link. proc_name=#{inspect({title, email})}")
    GenServer.start_link(__MODULE__, {quiz, email}, name: via({title, email}))
  end

  def take_quiz(quiz, email) do
    DynamicSupervisor.start_child(
      Mastery.Supervisor.QuizSession,
      {__MODULE__, {quiz, email}}
    )
  end

  def via({_quiz_title, _email} = name) do
    # A via tuple is a tuple that OTP uses to register a process.
    # They typically look like {:via, Registry, name}.
    # :via is a fixed atom signalling this technique to OTP.
    {:via, Registry, {Mastery.Registry.QuizSession, name}}
  end

  def select_question(name) do
    GenServer.call(via(name), :select_question)
  end

  def answer_question(name, answer) do
    GenServer.call(via(name), {:answer_question, answer})
  end

  def init({quiz, email}) do
    {:ok, {quiz, email}}
  end

  def handle_call(:select_question, _from, {quiz, email}) do
    new_quiz = Quiz.select_question(quiz)
    {:reply, new_quiz.current_question.asked, {new_quiz, email}}
  end

  def handle_call({:answer_question, answer}, _from, {quiz, email}) do
    resp = Response.new(quiz, email, answer)

    quiz
    |> Quiz.answer_question(resp)
    |> Quiz.select_question()
    |> maybe_finish(email)
  end

  defp maybe_finish(nil, _email), do: {:stop, :normal, :finished, nil}

  defp maybe_finish(quiz, email) do
    {:reply, {quiz.current_question.asked, quiz.last_response.correct}, {quiz, email}}
  end
end

# iex(2)> {:ok, session} = GenServer.start_link(Mastery.Boundary.QuizSession, {Mastery.Examples.Math.quiz(), "mathy@example.com"})
# {:ok, #PID<0.272.0>}
# iex(3)> Mastery.Boundary.QuizSession.select_question se
# self/0     send/2     session
# iex(3)> Mastery.Boundary.QuizSession.select_question session
# "0 + 7"
# iex(4)> Mastery.Boundary.QuizSession.answer_question session, "7"
# {"4 + 7", true}
# iex(5)> Mastery.Boundary.QuizSession.answer_question session, "11"
# :finished
