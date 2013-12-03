module HAR
  class Response < SchemaType

    attr_reader :entries

    def initialize(input)
      super(input)
    end

    def is_error?
      status >= 400
    end

    def is_client_error?
      is_error? && status < 500
    end

    def is_server_error?
      status >= 500 && status != 504
    end

    def is_connection_error?
      status == 504 || status == 0
    end

    def is_redirect?
      status == 301 || status == 302
    end

    def is_content_type? type
      !!content.mime_type.include?(type)
    end

    def is_html?
      is_content_type? 'html'
    end

    def is_image?
      is_content_type? 'image'
    end

    def is_javascript?
      is_content_type? 'javascript'
    end

    def is_css?
      is_content_type? 'css'
    end

    def is_flash?
      is_content_type? 'flash'
    end

    def is_other?
      !is_html? && !is_image? && !is_javascript? && !is_css? && !is_flash?
    end

  end
end