module Npmdc
  module Errors
    class Error < StandardError
      attr_reader :options

      def initialize(msg = nil, **options)
        @options = options

        super(msg)
      end

      def banner
        raise NotImplementedError, '#banner has to be implemented in subclass'
      end
    end

    class CheckerError < Error; end

    class NoNodeModulesError < CheckerError
      def banner
        path = options.fetch(:path)
        "Failed! Can't find `node_modules` folder inside '#{path}' directory!"
      end
    end

    class WrongPathError < CheckerError
      def banner
        directory = options.fetch(:directory)
        "There is no '#{directory}' directory."
      end
    end

    class MissedPackageError < CheckerError
      def banner
        directory = options.fetch(:directory)
        "There is no `package.json` file inside '#{directory}' directory."
      end
    end

    class JsonParseError < CheckerError
      def banner
        path = options.fetch(:path)
        "Can't parse JSON file #{path}"
      end
    end

    # Configuration Errors
    class UnknownFormatter < StandardError; end
  end
end
