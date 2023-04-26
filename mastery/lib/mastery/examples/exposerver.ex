defmodule Mastery.Examples.Exposerver do
  use GenServer

  def init(arg), do: {:ok, arg}

  def handle_call(msg, _from, state) do
    IO.puts("handle call #{inspect(msg)}")
    {:reply, :lol, state}
  end

  def handle_cast(:secret_tunnel, state) do
    Process.send_after(self(), "delayed facepalm", 1500)
    Process.send_after(self(), "secret tunnel!", 100)
    Process.send_after(self(), "in the mountain!", 200)
    {:noreply, state}
  end

  def handle_cast(msg, state) do
    IO.puts("handle cast #{inspect(msg)}")
    {:noreply, state}
  end

  def handle_info(msg, state) do
    IO.puts("handle info #{inspect(msg)}")
    {:noreply, state}
  end
end

# {:ok, pid} = GenServer.start_link(Mastery.Examples.Exposerver, [])
# send pid, "dork"
# GenServer.cast(pid, :secret_tunnel)
