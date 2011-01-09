module HAR
  class Error < StandardError; end
  class ValidationError < StandardError; end
end

require 'har/serializable'
require 'har/entry'
require 'har/page'
require 'har/archive'

require 'json'
require 'json-schema'
require 'time'
