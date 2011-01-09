module HAR
  class Page
    include Serializable
    include Commentable

    attr_reader :entries

    def initialize(input, entries)
      @data = input
      @entries = entries
    end

    def id
      @data.fetch('id')
    end

    def start_time
      Time.parse @data.fetch('startedDateTime')
    end

    def title
      @data.fetch 'title'
    end

    def page_timings
      @page_timings ||= PageTimings.new @data.fetch('pageTimings')
    end
  end
end