module HAR
  class PageTimings
    include Serializable
    include Commentable

    def initialize(data)
      @data = data
    end

    def on_content_load
      @data['onContentLoad']
    end

    def on_load
      @data['onLoad']
    end

  end
end
