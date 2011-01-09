module HAR
  class Response
    include Serializable
    include Commentable

    def initialize(data)
      @data = data
    end

    def status
      @data.fetch 'status'
    end

    def status_text
      @data.fetch 'statusText'
    end

    def http_version
      @data.fetch 'httpVersion'
    end

    def cookies
      raise NotImplementedError
    end

    def headers
      raise NotImplementedError
    end

    def content
      @content ||= Content.new @data.fetch('content')
    end

    def redirect_url
      @data.fetch 'redirectUrl'
    end

    def headers_size
      @data.fetch 'headersSize'
    end

    def body_size
      @data.fetch 'bodySize'
    end
  end # Response
end # HAR
