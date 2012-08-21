require 'active_support/core_ext/hash/slice'
require 'active_support/core_ext/hash/except'

VCR.configure do |c|
  c.cassette_library_dir  = File.join("spec", "vcr")
  c.hook_into :fakeweb
  c.default_cassette_options = {
    :match_requests_on => [:method, 
                            VCR.request_matchers.uri_without_params(
                              :oauth_timestamp, :oauth_signature, :oauth_nonce)]}
end

RSpec.configure do |c|
  c.treat_symbols_as_metadata_keys_with_true_values = true
  c.around(:each, :vcr) do |example|
    name = example.metadata[:full_description].split(/\s+/, 2).join("/").gsub(/[^\w\/]+/, "_")
    options = example.metadata.slice(:record, :match_requests_on).except(:example_group)
    VCR.use_cassette(name, options) { example.call }
  end
end
