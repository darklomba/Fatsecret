require 'spec_helper'
describe FatSecret do
  
  describe "configuration" do
  
    it "responds to configure" do
      FatSecret.should respond_to :configure
    end
    
    it "should return the configuration object" do
      config = FatSecret.configure { |config| config.api_key, config.api_secret = "key", "secret"}
      config.should be_kind_of FatSecret::Configuration
    end
    
    it "should set the api keys with a config block" do
      FatSecret.configure { |config| config.api_key, config.api_secret = "key", "secret"}
      config = FatSecret.configuration
      
      config.should be_kind_of FatSecret::Configuration
      config.api_key.should eq "key"
      config.api_secret.should eq "secret"
    end
    
    it "should set the api keys with direct assignment" do
      FatSecret.configuration.api_key = "NewKey"
      FatSecret.configuration.api_key.should eq "NewKey"
    end
  end
end
