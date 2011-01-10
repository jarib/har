module HAR
  class Page < SchemaType

    attr_reader :entries

    def initialize(input, entries)
      super(input)
      @entries = entries
    end

    # a little sugar
    alias_method :timings, :page_timings

  end
end