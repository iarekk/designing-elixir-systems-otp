import Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "mastery_test",
  hostname: "localhost",
  username: "ectotest",
  password: "ectotest",
  pool: Ecto.Adapters.SQL.Sandbox
