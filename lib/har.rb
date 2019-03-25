require 'json'
require 'jschematic'
require 'time'

require 'har/error'
require 'har/version'
require 'har/serializable'
require 'har/schema_type'
require 'har/page'
require 'har/page_timings'
require 'har/archive'
require 'har/viewer'
require 'har/extensions/jschematic/attributes/format'


module Enumerable
  def group_by
    assoc = {}

    each do |element|
      key = yield(element)

      if assoc.has_key?(key)
        assoc[key] << element
      else
        assoc[key] = [element]
      end
    end

    assoc
  end unless [].respond_to?(:group_by)
end