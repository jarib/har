module HAR
  class Request < SchemaType
    def initialize(input)
      super(input)
    end

    def domain
      URI.parse(url).host rescue url
    end
  end
end