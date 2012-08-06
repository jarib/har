module Jschematic
  module Attributes
    module Format

      # Looks like HAR files have slightly non-compliant dates,
      # so we override DateTime#accepts? to also check for that
      class DateTime
        alias_method :accepts_orig?, :accepts?

        def accepts?(date_time)
          accepts_orig?(date_time) || accepts_har_date?(date_time)
        end

        def accepts_har_date?(date_time)
          # taken from harSchema.js
          date_time =~ /^(\d{4})(-)?(\d\d)(-)?(\d\d)(T)?(\d\d)(:)?(\d\d)(:)?(\d\d)(\.\d+)?(Z|([+-])(\d\d)(:)?(\d\d))/
        end
      end
    end
  end
end
