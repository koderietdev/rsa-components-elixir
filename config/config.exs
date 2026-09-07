import Config

# Host apps point the library at their own Gettext backend. The library's
# own test suite needs one too, so it gets a minimal backend of its own.
if config_env() == :test do
  config :rsa_components, gettext_module: RsaComponents.TestGettext
end
