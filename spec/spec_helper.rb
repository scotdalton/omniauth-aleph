$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!
require 'rspec'
require 'rack/test'
require 'vcr'
require 'omniauth'
require 'omniauth-aleph'

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  # webmock needed for HTTPClient testing
  c.hook_into :faraday
  # c.debug_logger = $stderr
end
