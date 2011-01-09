module HAR
  class Request
    include Serializable
    include Commentable

    def initialize(data)
      @data = data
    end

    def method
      @data.fetch 'method'
    end

    def url
      @data.fetch 'url'
    end

    def headers_size
      @data.fetch 'headersSize'
    end

    def body_size
      @data.fetch 'bodySize'
    end
  end # Request
end # HAR
