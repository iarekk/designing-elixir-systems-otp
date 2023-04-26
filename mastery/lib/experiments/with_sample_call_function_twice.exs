alias Experiments.WithSample

WithSample.execute_function_safely_twice(&WithSample.work/1, 10, 20) |> IO.inspect

# ➜ mastery git:(main) ✗ mix run with_sample_call_function_twice.exs
# {:ok, [result: 8756, result: 13658]}
# ➜ mastery git:(main) ✗ mix run with_sample_call_function_twice.exs
# {:error, "oops!", 20}
