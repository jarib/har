$LOAD_PATH.unshift File.expand_path("../lib", __FILE__)
require "har"

module HAR
  module SpecHelper
    def fixture_path(name)
      File.join(File.expand_path("../fixtures", __FILE__), name)
    end
  end
end

RSpec.configure do |c|
  c.include HAR::SpecHelper
end