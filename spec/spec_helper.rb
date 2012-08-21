require 'rubygems'
require 'bundler/setup'
require 'active_model'
require 'vcr'
require 'fakeweb'
require "active_attr/rspec"

require 'fatsecret' # and any other gems you need


Dir["spec/support/**/*.rb"].each { |f| require File.expand_path(f) }

RSpec.configure do |config|
  config.color_enabled = true
end
