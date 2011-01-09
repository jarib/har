module HAR
  module Serializable
    def inspect
      '#<%s:0x%s>' % [self.class.name, self.hash.to_s(16)]
    end

    def ==(other)
      other.kind_of?(self.class) && as_json == other.as_json
    end

    alias_method :eql?, :==

    def as_json
      @data
    end

    def to_json(*args)
      as_json.to_json(*args)
    end

  end
end
