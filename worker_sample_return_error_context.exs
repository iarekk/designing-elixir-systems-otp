alias Experiments.WorkerSample
IO.puts "halt on error with context"

WorkerSample.stream_work()
|> Enum.take(3)
|> Enum.reduce_while(
[],
fn
  {:error, _error, _arg} = error, _results ->
    {:halt, error}
  {:result, r}, results ->
    {:cont, [r | results]}
end)
|> case do
{:error, _error, _arg} = error ->
  error
results ->
  Enum.reverse(results)
end
|> IO.inspect()

# ➜  mastery git:(main) ✗ mix run worker_sample_return_error_context.exs
# halt on error with context
# {:error, %RuntimeError{message: "oops!"}, 3}
# ➜  mastery git:(main) ✗ mix run worker_sample_return_error_contecx.exs
# halt on error with context
# [804, 1683, 1382]
