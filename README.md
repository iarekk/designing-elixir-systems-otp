# Mastery

Following the exercises from [Designing Elixir Systems with OTP](https://pragprog.com/titles/jgotp/designing-elixir-systems-with-otp/).

Some additions beyond the book material:

- extra unit tests, mostly showcasing Elixir's features, or expanding on concepts I found unfamiliar
- dialyzer and excoveralls tasks added (`mix dialyzer` and `mix coveralls.html` to invoke)
- run `iex --dot-iex lib/mastery/examples/api_run.exs -S mix` in the project root to play with the raw API
- finished Chapter 7 now :)
- now integratedd `mastery_persistence` into `mastery`

## Testing the persistence

1. Spin up a local Postgres instance through Docker: `docker run -itd -e POSTGRES_USER=ectotest -e POSTGRES_PASSWORD=ectotest -p 5432:5432 --name postgresql postgres`
2. Build both `mastery` and `mastery_persistence` (`cd` into folder, `mix deps.get`, `mix compile`)
3. `cd mastery_persistence && mix ecto.create && mix ecto.migrate`
4. `cd mastery` and run iex: `iex -S mix`
5. Run this in the shell:

    ```elixir
    > MasteryPersistence.record_response(%{
    quiz_title: "lol",
    template_name: "foo",
    to: "who dis?",
    email: "lol@email.com",
    answer: "interrupting cow",
    correct: true,
    timestamp: ~U[2019-10-31 19:59:03Z]
    })
    ```
4. Open a new terminal, run `docker exec -it postgresql /bin/bash`
5. In the terminal (on the PGSQL container), run `psql --username=ectotest` followed by  `\c mastery_dev`
6. Results:
    ```
    mastery_dev=# select * from responses;
    id | quiz_title | template_name |    to    |     email     |   answer         | correct | inserted_at         |     updated_at      
    ---+------------+---------------+----------+---------------+------------------+---------+---------------------+---------------------
     1 | lol        | foo           | who dis? | lol@email.com | interrupting cow | t       | 2019-10-31 19:59:03 | 2019-10-31 19:59:03
    (1 row)
    ```