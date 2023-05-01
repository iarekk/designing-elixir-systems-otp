defmodule Mastery.Boundary.Proctor do
  use GenServer
  require Logger
  alias Mastery.Boundary.{QuizManager, QuizSession}
  # alias Mastery.Core.{Quiz}

  def start_link(options \\ []) do
    GenServer.start_link(__MODULE__, [], options)
  end

  def init(quizzes) when is_list(quizzes) do
    {:ok, quizzes}
  end

  def schedule_quiz(proctor \\ __MODULE__, quiz, temps, start_at, end_at, notify_pid) do
    quiz = %{
      fields: quiz,
      templates: temps,
      start_at: start_at,
      end_at: end_at,
      notify_pid: notify_pid
    }

    GenServer.call(proctor, {:schedule_quiz, quiz})
  end

  def handle_call({:schedule_quiz, quiz}, _from, quizzes) do
    now = DateTime.utc_now()

    not_ready_quizzes =
      [quiz | quizzes]
      |> start_quizzes(now)

    # repl can be either
    # {:reply, :ok, [...list of quizzes...], 15000}, the last 3 correspond to response, state, and a timeout
    # or {:reply, :ok, []}, which means that we have no more quizzes planned in the next while
    # the timeout will trigger the handle_info with the :timeout message, unless new messages arrive in the meantime
    # see timeouts info here: https://hexdocs.pm/elixir/1.14/GenServer.html#module-timeouts
    repl = build_reply_with_timeout({:reply, :ok}, not_ready_quizzes, now)
    # IO.puts("handle_call reply: #{inspect(repl, pretty: true)}")
    repl
  end

  def handle_info(:timeout, quizzes) do
    # IO.puts("handle_info :timeout")
    now = DateTime.utc_now()

    remaining_quizzes = start_quizzes(quizzes, now)
    repl = build_reply_with_timeout({:noreply}, remaining_quizzes, now)
    # IO.puts("handle_info reply: #{inspect(repl, pretty: true)}")
    repl
  end

  def handle_info({:end_quiz, title, notify_pid}, quizzes) do
    QuizManager.remove_quiz(title)

    title
    |> QuizSession.active_sessions_for()
    |> QuizSession.end_sessions()

    Logger.info("Stopped quiz #{title}.")
    notify_stopped(notify_pid, title)
    handle_info(:timeout, quizzes)
  end

  def build_reply_with_timeout(reply, quizzes, now) do
    reply
    |> append_state(quizzes)
    |> maybe_append_timeout(quizzes, now)
  end

  defp append_state(tuple, quizzes), do: Tuple.append(tuple, quizzes)

  defp maybe_append_timeout(tuple, [], _now), do: tuple
  defp maybe_append_timeout(tuple, quizzes, now), do: append_timeout(tuple, quizzes, now)

  defp append_timeout(tuple, quizzes, now) do
    timeout =
      quizzes
      |> hd
      |> Map.fetch!(:start_at)
      |> DateTime.diff(now, :millisecond)

    Tuple.append(tuple, timeout)
  end

  defp start_quizzes(quizzes, now) do
    # IO.puts("start_quizzes inputs: #{inspect(Enum.map(quizzes, & &1.start_at))}")

    sorted_quizzes = Enum.sort_by(quizzes, & &1.start_at, DateTime)

    {ready, not_ready} =
      Enum.split_with(sorted_quizzes, fn quiz ->
        DateTime.compare(quiz.start_at, now) in ~w[lt eq]a
      end)

    Enum.each(ready, fn quiz -> start_quiz(quiz, now) end)
    not_ready
  end

  def start_quiz(quiz, now) do
    title = Keyword.fetch!(quiz.fields, :title)
    Logger.info("Starting quiz #{title}.")
    notify_start(quiz)
    QuizManager.build_quiz(quiz.fields)
    Enum.each(quiz.templates, &QuizManager.add_template(title, &1))
    timeout = DateTime.diff(quiz.end_at, now, :millisecond)
    # end the quiz after a timeout
    Process.send_after(self(), {:end_quiz, title, quiz.notify_pid}, timeout)
  end

  defp notify_start(%{notify_pid: nil}), do: nil

  defp notify_start(quiz),
    do: send(quiz.notify_pid, {:started, Keyword.fetch!(quiz.fields, :title)})

  defp notify_stopped(nil, _title), do: nil
  defp notify_stopped(pid, title), do: send(pid, {:stopped, title})
end
