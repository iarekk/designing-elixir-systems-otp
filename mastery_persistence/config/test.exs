import Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "ectotest",
  hostname: "localhost",
  username: "ectotest",
  password: "ectotest",
  pool: Ecto.Adapters.SQL.Sandbox
