defmodule ResponseTest do
  use QuizBuilders
  use ExUnit.Case

  describe "a right response and a wrong response" do
    # the list of one-arity functions to be invoked, populating the context
    # invoked 3 times, for each test below
    setup [:right, :wrong, :correcto_method, :setup_marker]

    test "building responses checks answers", %{
      right: right,
      wrong: wrong,
      # binds the value under the `correcto_atom` key to the variable `correcto_in_test`
      correcto_atom: correcto_in_test
    } do
      assert right.correct
      assert correcto_in_test.correct
      refute wrong.correct
    end

    test "a timestamp is added at build time", %{right: response} do
      assert %DateTime{} = response.timestamp
      assert response.timestamp < DateTime.utc_now()
    end

    test "just burning electricity", _context do
      assert true
    end
  end

  defp quiz() do
    fields = template_fields(generators: %{left: [1], right: [2]})

    build_quiz()
    |> Quiz.add_template(fields)
    |> Quiz.select_question()
  end

  defp response(answer) do
    Response.new(quiz(), "mathy@example.com", answer)
  end

  defp right(context) do
    # IO.puts("context right: #{inspect(context)}")
    {:ok, Map.put(context, :right, response("3"))}
  end

  defp wrong(context) do
    # IO.puts("context wrong: #{inspect(context)}")
    {:ok, Map.put(context, :wrong, response("2"))}
  end

  defp correcto_method(context) do
    # IO.puts("context correcto_method: #{inspect(context)}")
    {:ok, Map.put(context, :correcto_atom, response("3"))}
  end

  defp setup_marker(context) do
    IO.puts("setup called for '#{context.test}'")
  end
end
