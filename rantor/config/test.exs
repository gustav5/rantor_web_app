import Config

# We don't run a server during test. If one is required,
# you can enable the server option below.
config :rantor, RantorWeb.Endpoint,
  http: [ip: {127, 0, 0, 1}, port: 4002],
  secret_key_base: "UPEUSscoY0YFxqcEt9J9Xzmc1bnUq8WNt6nn3PgpEdy6TZCNf5Lr6V2ANROfiwRK",
  server: false

# In test we don't send emails.
config :rantor, Rantor.Mailer,
  adapter: Swoosh.Adapters.Test

# Print only warnings and errors during test
config :logger, level: :warn

# Initialize plugs at runtime for faster test compilation
config :phoenix, :plug_init_mode, :runtime
