require 'npmdc/errors'

module Npmdc
  module Checkers
    module Errors
      class CheckerError < Npmdc::Errors::Error
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

        private

        def manager
          options.fetch(:manager)
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

      class NoNodeModulesError < CheckerError
        define_critical!

        def banner
          path = options.fetch(:path)
          [
            "Can't find `node_modules` folder inside '#{path}' directory!",
            ["\n" + manager.command_to_resolve_missing_packages, :warn]
          ]
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
            "\n" + manager.command_to_resolve_missing_packages(deps.count), :warn
          ]
        end

        private

        def msgs(dependencies)
          dependencies.map { |d| "  * #{d}"}
        end
      end
    end
  end
end
