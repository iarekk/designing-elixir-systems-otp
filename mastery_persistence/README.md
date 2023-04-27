# MasteryPersistence

To spin up local Posgres, run `docker run -itd -e POSTGRES_USER=ectotest -e POSTGRES_PASSWORD=ectotest -p 5432:5432 --name postgresql postgres`
## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `mastery_persistence` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:mastery_persistence, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at <https://hexdocs.pm/mastery_persistence>.

