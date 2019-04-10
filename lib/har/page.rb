module HAR
  class Page < SchemaType

    attr_reader :entries

    def initialize(input, entries)
      super(input)
      @entries = entries
    end

    # a little sugar
    alias_method :timings, :page_timings

    # Filter entries that *finished* before the specified time
    def entries_before(time)
      raise TypeError, "expected Time" unless time.is_a?(Time)
      entries.select do |entry|
        return false unless entry.time
        entry.started_date_time + entry.time / 1000.0 <= time
      end
    end
  end
end