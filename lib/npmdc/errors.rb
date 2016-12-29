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

    class CheckerError < Error
        def initialize(*)
          super
        end

        def critical?
          self.class.critical?
        end

        @critical = false

        class << self
          attr_reader :critical
          alias_method :critical?, :critical

          private

          def define_critical!
            @critical = true
          end
        end
    end

    class NoNodeModulesError < CheckerError
      define_critical!

      def banner
        path = options.fetch(:path)
        [
          "Can't find `node_modules` folder inside '#{path}' directory!",
          ["\nRun `npm install` to install missing packages.", :warn]
        ]
      end
    end

    class WrongPathError < CheckerError
      define_critical!

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
      define_critical!

      def banner
        path = options.fetch(:path)
        "Can't parse JSON file #{path}"
      end
    end

    class MissedDependencyError < CheckerError
      define_critical!

      def banner
        deps = options.fetch(:dependencies)

        [
          "Following dependencies required by your package.json file are"\
          " missing or not installed properly:"
        ] + msgs(deps) <<
        [
          "\nRun `npm install` to install #{deps.size} missing packages.", :warn
        ]
      end

      private

      def msgs(dependencies)
        dependencies.map { |d| "  * #{d}"}
      end
    end

    class UnknownFormatter < ConfigurationError
      def banner
        formatter = options.fetch(:formatter)

        "Unknown '#{formatter}' formatter"
      end
    end
  end
end
