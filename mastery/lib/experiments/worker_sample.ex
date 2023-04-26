defmodule Experiments.WorkerSample do
  def work(n) do
    if :rand.uniform(10) == 1 do
      IO.puts("oops happened #{n}")
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

# iex> Experiments.WorkerSample.stream_work |> Enum.take(20)
# oops happened 3
# oops happened 5
# oops happened 14
# [
#   {:result, 139},
#   {:result, 1979},
#   {:error, %RuntimeError{message: "oops!"}, 3},
#   {:result, 2328},
#   {:error, %RuntimeError{message: "oops!"}, 5},
#   {:result, 4984},
#   {:result, 593},
#   {:result, 5683},
#   {:result, 5617},
#   {:result, 4157},
#   {:result, 10051},
#   {:result, 497},
#   {:result, 5725},
#   {:error, %RuntimeError{message: "oops!"}, 14},
#   {:result, 2354},
#   {:result, 5631},
#   {:result, 9136},
#   {:result, 8749},
#   {:result, 1472},
#   {:result, 2898}
# ]
