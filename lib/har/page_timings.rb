module HAR
  class PageTimings < SchemaType
    def initialize(input)
      super(input)
      define_custom_timings(input)
    end

    private

    # As defined by the HAR spec, custom timings must start with an underscore.
    # To prevent collisions, the methods generated for those custom timings will
    # also start with an underscore.
    def define_custom_timings(input)
      input.each do |key, value|
        define_singleton_method(key) { value } if key.start_with?('_')
      end
    end
  end
end
