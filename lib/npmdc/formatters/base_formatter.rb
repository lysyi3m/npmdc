require 'colorized_string'

module Npmdc
  module Formatters
    class BaseFormatter

      COLORS = {
        success: :green,
        failure: :red,
        warn: :yellow,
        info: :white
      }.freeze

      def initialize(options, output = Npmdc.output)
        @options = options
        @output = output
        @disable_colorization = !@options.fetch(:color, true)
      end

      def output(message, status = nil)
        @output.puts color_message(message, status)
      end

      def dep_output(dep, status)
        # no-op
      end

      def check_finish_output
        @output.puts "\n"
      end

      def check_start_output(type)
        @output.puts "Checking #{type}:"
      end

      def color_message(message, status = nil)
        if @disable_colorization || !status
          message
        else
          ColorizedString[message].colorize(color(status))
        end
      end

      def color(status)
        COLORS[status]
      end
    end
  end
end