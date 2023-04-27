import Config

config :mastery_persistence, MasteryPersistence.Repo,
  database: "mastery_dev",
  hostname: "localhost",
  username: "ectotest",
  password: "ectotest"

config :mastery, :persistence_fn, &MasteryPersistence.record_response/2
