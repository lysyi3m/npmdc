module Npmdc
  module Errors
    class Error < StandardError
      attr_reader :options

      def initialize(msg = nil, **options)
        @options = options

        super(msg)
      end

      def banner
        raise(NotImplementedError, '#banner has to be implemented in subclass')
      end
    end

    class ConfigurationError < Error; end

    class UnknownFormatter < ConfigurationError
      def banner
        formatter = options.fetch(:formatter)

        "Unknown '#{formatter}' formatter"
      end
    end

    class UnknownPackageManager < ConfigurationError
      def banner
        package_manager = options.fetch(:package_manager)

        "Unknown '#{package_manager}' package manager"
      end
    end
  end
end
