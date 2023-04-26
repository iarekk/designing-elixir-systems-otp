defmodule Experiments.WithSample do
  def work(n) do
    if :rand.uniform(10) == 1 do
      {:error, "oops!", n}
    else
      {:result, :rand.uniform(n * 1000)}
    end
  end

  def execute_function_safely_twice(dangerous_work, arg1, arg2) do
    with {:result, _val1} = good_result1 <- apply(dangerous_work, [arg1]),
         {:result, _val2} = good_result2 <- apply(dangerous_work, [arg2]) do
      {:ok, [good_result1, good_result2]}
    else
      error_message -> error_message
    end
  end
end
