require 'colorize'
require 'npmdc/formatter'
require 'npmdc/checkers/errors'
require 'npmdc/checkers/npm/npm_checker'
require 'npmdc/checkers/yarn/yarn_checker'

module Npmdc
  module Checkers
    class Checker
      include Npmdc::Errors

      attr_reader :path, :formatter, :types

      def initialize(options)
        @package_manager = options.fetch('package_manager', Npmdc.config.package_manager)
        @path_to_yarn = options.fetch('path_to_yarn', Npmdc.config.path_to_yarn)
        @path = options.fetch('path', Npmdc.config.path)
        @types = options.fetch('types', Npmdc.config.types)
        @abort_on_failure = options.fetch('abort_on_failure', Npmdc.config.abort_on_failure)
        @formatter = Npmdc::Formatter.(options)
      end

      def call
        checker =
          if @package_manager == 'npm'
            Npm::NpmChecker.new(
              types: @types,
              formatter: @formatter,
              path: path,
            )
          elsif @package_manager == 'yarn'
            Yarn::YarnChecker.new(
              types: @types,
              formatter: @formatter,
              path: path,
              path_to_yarn: @path_to_yarn,
            )
          else
            raise UnknownPackageManager, package_manager: @package_manager
          end

        checker.call

        true
      rescue Errors::CheckerError => e
        formatter.error_output(e)

        exit(1) if @abort_on_failure && e.class.critical?

        false
      end
    end
  end
end
