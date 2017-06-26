$:.unshift File.expand_path('..', __FILE__)
$:.unshift File.expand_path('../../lib', __FILE__)
require 'coveralls'
Coveralls.wear!
require 'rspec'
require 'rack/test'
require 'vcr'
require 'faraday'
require 'omniauth'
require 'omniauth-aleph'
require 'pry'

def aleph_host
  @aleph_host ||= (ENV['ALEPH_HOST'] || 'aleph.library.edu')
end

def aleph_username
  @aleph_username ||= (ENV['ALEPH_USERNAME'] || "USERNAME")
end

def aleph_password
  @aleph_password ||= (ENV['ALEPH_PASSWORD'] || "PASSWORD")
end

def aleph_email
  @aleph_email ||= (ENV['ALEPH_EMAIL'] || "username@library.edu")
end

def aleph_library
  @aleph_library ||= (ENV['ALEPH_LIBRARY'] || "ADM50")
end

def aleph_sub_library
  @aleph_sub_library ||= (ENV['ALEPH_SUB_LIBRARY'] || "SUB")
end

VCR.configure do |c|
  c.cassette_library_dir = 'spec/vcr_cassettes'
  c.configure_rspec_metadata!
  c.hook_into :webmock
  c.filter_sensitive_data("aleph.library.edu") { aleph_host }
  c.filter_sensitive_data("USERNAME") { aleph_username }
  c.filter_sensitive_data("username") { aleph_username.downcase }
  c.filter_sensitive_data("verification=PASSWORD") { "verification=#{aleph_password}" }
  c.filter_sensitive_data("username@library.edu") { aleph_email }
  c.filter_sensitive_data("ADM50") { aleph_library }
  c.filter_sensitive_data("SUB") { aleph_sub_library }
end

RSpec.configure do |config|
  config.include Rack::Test::Methods
  config.extend OmniAuth::Test::StrategyMacros, :type => :strategy
  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end
