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

    DEFAULT_FORMAT = :short

    class << self
      def call(options)
        fmt = options.fetch('format', DEFAULT_FORMAT)
        FORMATTERS[fmt.to_sym].new(options)
      end
    end
  end
end
