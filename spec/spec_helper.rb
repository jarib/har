$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "har"

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
  end
end

RSpec.configure do |c|
  c.include HAR::SpecHelper
end