import Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "mastery_test",
  hostname: "postgres",
  username: "ectotest",
  password: "ectotest",
  pool: Ecto.Adapters.SQL.Sandbox
