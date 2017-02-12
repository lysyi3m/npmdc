require 'npmdc/formatters/progress'
require 'npmdc/formatters/documentation'
require 'npmdc/formatters/short'

module Npmdc
  module Formatter
    FORMATTERS = {
      progress: Npmdc::Formatters::Progress,
      doc:      Npmdc::Formatters::Documentation,
      short:    Npmdc::Formatters::Short
    }.freeze

    class << self
      def call(options)
        fmt = options.fetch('format', Npmdc.config.format)
        klass(fmt).new(options)
      end

      private

      def klass(fmt)
        FORMATTERS[fmt.to_sym] ||
          raise(Npmdc::Errors::UnknownFormatter, formatter: fmt)
      end
    end
  end
end
