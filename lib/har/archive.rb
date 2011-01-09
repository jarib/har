module HAR
  class Archive
    def self.from_string(str, uri = nil)
      new JSON.parse(str), uri
    end

    def self.from_file(path)
      from_string File.read(path), path
    end

    attr_reader :uri

    def initialize(input, uri = nil)
      @input = input
      @uri   = uri
    end

    def ==(other)
      other.kind_of?(self.class) && @input == other.input
    end
    alias_method :eql?, :==

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
      merge_data input, other.input, other.uri

      self.class.new input
    end

    # destructively merge this with the given archive

    def merge!(other)
      assert_archive other
      clear_caches

      merge_data @input, other.input, other.uri
      nil
    end

    def save_to(path)
      File.open(path, "w") { |io| io << @input.to_json }
    end

    def valid?
      JSON::Validator.validate schema_file, @input
    end

    def validate!
      JSON::Validator.validate2 schema_file, @input
    rescue JSON::ValidationError => ex
      # add archive uri to the message
      if @uri
        raise ValidationError, "#{@uri}: #{ex.message}"
      else
        raise ValidationError, ex.message
      end
    end

    protected

    def input
      @input
    end

    private

    def schema_file
      @schema_file ||= File.expand_path("../schemas/logType", __FILE__)
    end

    def merge_data(left, right, uri)
      log       = left.fetch('log')
      other_log = right.fetch('log')

      pages   = log.fetch('pages')
      entries = log.fetch('entries')

      other_pages = other_log.fetch("pages")
      other_entries = other_log.fetch("entries")

      if uri
        deep_clone(other_pages).each do |page|
          c = page['comment'] ||= ''
          c << "(merged from #{File.basename uri})"

          pages << page
        end
      else
        pages.concat other_pages
      end

      entries.concat other_entries
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

