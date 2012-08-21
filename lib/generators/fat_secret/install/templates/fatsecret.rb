require 'fatsecret-models'

FatSecret.configure do |config|
  # Config options include:
  #   api_key
  #   api_secret
  #   api_url (defaults to the current fatsecret api http://platform.fatsecret.com/rest/server.api) 
  #   api_methods (an array of methods for the fs api currently [food, recipies], more can be added)
  #   oauth_token (for future implementation with user-specific information)
  #
  # uncomment the following two lines and add your information
  #config.api_key =
  #config.api_secret =
end
