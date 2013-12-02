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

module HAR
  module SpecHelper
    def fixture_path(name)
      File.join(File.expand_path("../fixtures", __FILE__), name)
    end

    def har_path(name)
      fixture_path File.join("hars", "#{name}.har")
    end

    def json(path)
      JSON.parse(File.read(path))
    end

    def all_hars
      Dir[fixture_path("hars/*.har")]
    end

    def google_path
      har_path "google.com"
    end

    def good_hars
      all_hars.reject { |e| e =~ /bad/ }
    end

    def with_stdin_replaced_by(file_path)
      stdin = $stdin
      begin
        File.open(file_path, "r") { |io|
          $stdin = io
          yield
        }
      ensure
        $stdin = stdin
      end
    end

    def har_url_path(name)
      # use files from github for URL testing
      "https://raw.github.com/Rigor/har/master/spec/fixtures/hars/#{name}"
    end
  end
end

RSpec.configure do |c|
  c.include HAR::SpecHelper
end
