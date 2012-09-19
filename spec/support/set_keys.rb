def set_keys
  FatSecret.configure do |config|
    config.api_key = ""
    config.api_secret = ""
  end
  config = FatSecret.configuration
  raise RuntimeError, "One or more api_keys not set" unless config.api_key && config.api_secret
end
