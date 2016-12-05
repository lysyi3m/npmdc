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
        FORMATTERS[fmt.to_sym].new(options)
      end
    end
  end
end
