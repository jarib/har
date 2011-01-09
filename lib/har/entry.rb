module HAR
  class Entry
    include Serializable
    include Commentable

    def initialize(data)
      @data = data
    end

    def pageref
      @data['pageref']
    end

    def start_time
      Time.parse @data.fetch('startedDateTime')
    end

    def time
      @data.fetch 'time'
    end

    def request
      @request ||= Request.new @data.fetch('request')
    end

    def response
      @response ||= Response.new @data.fetch('response')
    end

    def cache
      raise NotImplementedError
    end

    def timings
      raise NotImplementedError
    end

    def server_ip_address
      @data['serverIPAddress']
    end

    def connection
      @data['connection']
    end

    private

    def timings
      @data.fetch 'timings'
    end

    def content
      response.fetch('content')
    end

  end # Entry
end # Archive