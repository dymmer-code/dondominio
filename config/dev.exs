import Config

config :don_dominio,
  url: System.get_env("URL"),
  apiuser: System.get_env("APIUSER"),
  apipasswd: System.get_env("APIPASSWD")
