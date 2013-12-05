if ENV['COVERAGE']
  raise "simplecov only works on 1.9" unless RUBY_PLATFORM >= "1.9"
  require 'simplecov'
  SimpleCov.start {
    add_filter "spec/"
  }
end

require 'webmock/rspec'
require 'vcr'

# Requires supporting ruby files in spec/support/ and its subdirectories.
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require 'har'
require 'pry'

RSpec.configure do |c|
  c.include HAR::SpecHelper
end
