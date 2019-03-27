module HAR
  class PageTimings < SchemaType
    def initialize(input)
      super(input)
      @input = input
    end

    def custom
      @custom ||= begin
        # TODO: move to `transform_keys` once ruby 2.0.0 support is dropped
        custom_timings = Hash[@input.select { |key| key.start_with?('_') }
                                    .map { |key, val| [key[1..-1], val] }]

        OpenStruct.new(custom_timings)
      end
    end
  end
end
