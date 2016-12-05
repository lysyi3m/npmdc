Dir["#{File.dirname(__FILE__)}/formatters/*.rb"].each { |file| require file }

module Npmdc
  module Formatter

    FORMATTERS = {
      progress: Npmdc::Formatters::ProgressFormatter,
      doc:      Npmdc::Formatters::DocumentationFormatter,
      short:    Npmdc::Formatters::ShortFormatter,
    }.freeze

    DEFAULT_FORMAT = :short

    class << self
      def call(options)
        fmt = options.fetch(:format, DEFAULT_FORMAT)
        FORMATTERS[fmt.to_sym].new(options)
      end
    end
  end
end
