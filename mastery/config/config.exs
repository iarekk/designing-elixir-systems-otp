import Config

config :mastery_persistence,
  ecto_repos: [MasteryPersistence.Repo]

config :logger, level: :info
config :mastery, :persistence_fn, &MasteryPersistence.record_response/2

import_config "#{Mix.env()}.exs"
