module HAR
  class Entry
    class Entry
      def initialize(data)
        @data = data
      end

      def start_time
        Time.parse @data.fetch('startedDateTime')
      end

      def time
        @data.fetch 'time'
      end

      def method
        request.fetch 'method'
      end

      def url
        request.fetch 'url'
      end

      def request_headers_size
        request.fetch 'headersSize'
      end

      def request_body_size
        request.fetch 'bodySize'
      end

      def status
        response.fetch 'status'
      end

      def status_text
        response.fetch 'statusText'
      end

      def response_headers_size
        response.fetch 'headersSize'
      end

      def response_body_size
        response.fetch 'bodySize'
      end

      def mime_type
        content.fetch 'mimeType'
      end

      def content_size
        content.fetch 'size'
      end

      private

      def request
        @data.fetch 'request'
      end

      def response
        @data.fetch 'response'
      end

      def timings
        @data.fetch 'timings'
      end

      def content
        response.fetch('content')
      end
    end

  end # Entry
end #