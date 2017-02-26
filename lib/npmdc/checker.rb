require 'colorize'
require 'json'
require 'forwardable'
require 'semantic_range'
require 'npmdc/formatter'
require 'npmdc/errors'
require 'npmdc/checkers/npm/npm_checker'
require 'npmdc/checkers/yarn/yarn_checker'

module Npmdc
  module Checkers
    class Checker
      extend Forwardable
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

      delegate [
        :output, :error_output, :dep_output,
        :check_start_output, :check_finish_output
      ] => :formatter

      def call
        checker =
          if @package_manager == 'npm'
            NpmChecker.new(
              types: @types,
              formatter: @formatter,
              path: path,
            )
          elsif @package_manager == 'yarn'
            YarnChecker.new(
              types: @types,
              formatter: @formatter,
              path: path,
              path_to_yarn: @path_to_yarn,
            )
          else
            raise UnknownPackageManager, package_manager: @package_manager
          end

        checker.check

        true
      rescue CheckerError => e
        error_output(e)

        exit(1) if @abort_on_failure && e.class.critical?

        false
      end
    end
  end
end
