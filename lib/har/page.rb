module HAR
  class Page < SchemaType
    attr_reader :entries

    def initialize(input, entries)
      super(input)
      @entries = entries
    end

    # a little sugar
    alias_method :timings, :page_timings

    def is_redirect?
      entries.first.response.is_redirect?
    end
  end
end