require_relative './base'

module Npmdc
  module Formatters
    class Progress < Base
      def dep_output(_dep, status)
        case status
        when :success
          @output.print color_message(".", status)
        when :failure
          @output.print color_message("F", status)
        when :warn
          @output.print color_message("W", status)
        end
      end

      def check_finish_output
        2.times { @output.puts "\n" }
      end
    end
  end
end
