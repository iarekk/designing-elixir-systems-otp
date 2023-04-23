IO.puts "Report partial success:"
Experiments.WorkerSample.stream_work
|> Enum.take(10)
|> IO.inspect

# sh> mix run worker_sample_test.exs
# Report partial success:
# [
#   {:result, 64},
#   {:result, 1720},
#   {:result, 111},
#   {:result, 2941},
#   {:result, 1422},
#   {:result, 4790},
#   {:result, 6674},
#   {:error, %RuntimeError{message: "oops!"}, 8},
#   {:result, 2225},
#   {:result, 4208}
# ]
