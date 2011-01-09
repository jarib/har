module HAR
  class Page
    attr_reader :entries

    def initialize(data, entries)
      @data = data
      @entries = entries
    end

    def start_time
      Time.parse @data.fetch('startedDateTime')
    end

    def title
      @data.fetch 'title'
    end

    def on_content_load
      timings.fetch 'onContentLoad'
    end

    def on_load
      timings.fetch 'onLoad'
    end

    private

    def timings
      @data.fetch('pageTimings')
    end
  end
end