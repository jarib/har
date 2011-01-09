require "pp"

module HAR
  class SchemaType
    include Serializable

    class << self
      private

      def load_from(file)
        schema = JSON.parse(File.read(file))

        klass = Class.new(self) do
          schema['properties'].each do |name, definition|
            define_property name, definition
          end
        end

        HAR.const_set type_name_from(schema['id']), klass
      end

      def define_property(name, definition)
        required = definition['required']
        type     = definition['type']

        wrapper = extract_wrapper(name, definition)

        fetch_code = required ? "@data.fetch(#{name.inspect})" : "@data[#{name.inspect}]"
        fetch_code = "#{wrapper} #{fetch_code}" if wrapper

        class_eval "
          def #{snake_case name}
            @#{name} ||= #{fetch_code}
          end
        "
      end

      def extract_wrapper(name, definition)
        type = definition['type']

        case type
        when 'object'
          return "#{name.capitalize}.new"
        when 'string'
          if definition['format'] == 'date-time'
            return 'Time.parse'
          end
        when Hash
          ref = type['$ref']
        when nil
          ref = definition['$ref']
        end

        "#{type_name_from(ref)}.new" if ref
      end

      def type_name_from(str)
        t = str[/^(.+)Type/, 1] or raise Error, "could not extract type name from #{str.inspect}"
        t[0] = t[0].chr.upcase

        t
      end

      def snake_case(str)
        str.gsub(/\B[A-Z][^A-Z]/, '_\&').downcase.gsub(' ', '_')
      end
    end

    def initialize(data)
      @data = data
    end

    # load in schemas
    Dir[File.expand_path("../schemas/*", __FILE__)].each do |file|
      load_from file
    end
  end # SchemaType
end # HAR
