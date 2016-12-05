module Npmdc
  module Formatters
    class DocumentationFormatter < BaseFormatter
      def dep_output(dep, status)
        case status
        when :success
          @output.puts color_message("  ✓ #{dep}", status)
        when :failure
          @output.puts color_message("  ✗ #{dep}", status)
        end
      end
    end
  end
end