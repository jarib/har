module HAR
  class Archive
    def self.from_string(str)
      new JSON.parse(str)
    end

    def self.from_file(path)
      from_string File.read(path)
    end

    def initialize(input)
      @input = input
    end

    def pages
      @pages ||= raw_log.fetch('pages').map { |page|
        Page.new page, entries_for(page['id'])
      }
    end

    def entries
      @entries ||= raw_entries.map { |e| Entry.new(e) }
    end

    # create a new archive by merging this and another archive

    def merge(other)
      assert_archive other

      input = deep_clone(@input)
      merge_data input, other.input

      self.class.new input
    end

    # destructively merge this with the given archive

    def merge!(other)
      assert_archive other
      clear_caches

      merge_data @input, other.input
      nil
    end

    protected

    def input
      @input
    end

    private

    def merge_data(left, right)
      log       = left.fetch('log')
      other_log = right.fetch('log')

      pages   = log.fetch('pages')
      entries = log.fetch('entries')

      pages.concat other_log.fetch('pages')
      entries.concat other_log.fetch('entries')
    end

    def assert_archive(other)
      unless other.kind_of?(self.class)
        raise TypeError, "expected #{self.class}"
      end
    end

    def clear_caches
      @raw_entries = @entries_map = @pages = @entries = @log = nil
    end

    def entries_for(page_id)
      entries = entries_map[page_id] || []
      entries.map { |e| Entry.new(e) }
    end

    def raw_entries
      @raw_entries ||= raw_log.fetch('entries')
    end

    def raw_log
      @raw_log ||= @input.fetch 'log'
    end

    def entries_map
      @entries_map ||= raw_entries.group_by { |e| e['pageref'] }
    end

    def deep_clone(obj)
      Marshal.load Marshal.dump(obj)
    end

  end # Archive
end # HAR

