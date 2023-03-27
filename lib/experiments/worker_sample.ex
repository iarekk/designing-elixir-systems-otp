defmodule Experiments.WorkerSample do
  def work(n) do
    if :rand.uniform(10) == 1 do
      raise "oops!"
    else
      {:result, :rand.uniform(n * 1000)}
    end
  end

  def make_work_safe(dangerous_work, arg) do
    try do
      apply(dangerous_work, [arg])
    rescue
      error -> {:error, error, arg}
    end
  end

  def stream_work do
    # &(&1+1)
    Stream.iterate(1, fn i -> i + 1 end)
    |> Stream.map(fn i -> make_work_safe(&work/1, i) end)
  end
end

# iex> Mastery.Core.WorkerSample.stream_work() |> Enum.take(10)

# [
#   {:result, 395},
#   {:result, 1894},
#   {:result, 2449},
#   {:error, %RuntimeError{message: "oops!"}, 4},
#   {:result, 4416},
#   {:result, 3631},
#   {:result, 3155},
#   {:result, 7736},
#   {:result, 2585},
#   {:result, 8095}
# ]
