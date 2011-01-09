module HAR
  class Content
    include Serializable
    include Commentable

    # "size": {"type": "integer", "required": true},
    # "compression": {"type": "integer"},
    # "mimeType": {"type": "string", "required": true},
    # "text": {"type": "string"},
    # "encoding": {"type": "string"},
    # "comment": {"type": "string"}

    def initialize(data)
      @data = data
    end

    def size
      @data.fetch 'size'
    end

    def compression
      @data['compression']
    end

    def mime_type
      @data.fetch 'mimeType'
    end

    def text
      @data['text']
    end

    def encoding
      @data['encoding']
    end
  end
end