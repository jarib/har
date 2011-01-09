module HAR
  class Archive
    def self.from_string(str)
      new JSON.parse(str)
    end

    def self.from_file(path)
      from_string File.read(path)
    end

    def initialize(hash)
      @data = hash.fetch 'log'
    end

    def pages
      @data.fetch('pages').map do |page|
        Page.new page, entries_for(page['id'])
      end
    end

    def entries
      raw_entries.map { |e| Entry.new(e) }
    end

    # create a new archive by merging this and another archive

    def merge(other)
      raise NotImplementedError
    end

    # destructively merge this with the given archive

    def merge!(other)
      raise NotImplementedError
    end

    private

    def entries_for(page_id)
      raw_entries.map { |e|
        Entry.new(e) if e['pageref'] == page_id
      }.compact
    end

    def raw_entries
      @data.fetch('entries')
    end

  end # Archive
end # HAR

