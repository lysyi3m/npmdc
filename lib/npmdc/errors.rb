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
        @critical = false

        class << self
          def critical?
            @critical
          end

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
          [command_to_resolve_errors, :warn]
        ]
      end

      private

      def command_to_resolve_errors
        case options.fetch(:manager)
        when 'npm'
          "\nRun `npm install` to install missing packages."
        when 'yarn'
          "\nRun `yarn` to install missing packages."
        end
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

    class NoYarnLockFileError < CheckerError
      define_critical!

      def banner
        "No lockfile in this directory. Run `yarn install` to generate one."
      end
    end

    class YarnNotInstalledError < CheckerError
      define_critical!

      def banner
        "Failed to find `#{options.fetch(:yarn_command)}`. Check that `yarn` is installed, please."
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
          command_to_resolve_errors(deps), :warn
        ]
      end

      private

      def msgs(dependencies)
        dependencies.map { |d| "  * #{d}"}
      end

      def command_to_resolve_errors(deps)
        case options.fetch(:manager)
        when 'npm'
          "\nRun `npm install` to install #{deps.size} missing packages."
        when 'yarn'
          "\nRun `yarn` to install missing packages."
        end
      end
    end

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
