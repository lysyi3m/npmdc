require 'forwardable'
require 'json'
require 'npmdc/checkers/errors'

module Npmdc
  module Checkers
    class Base
      extend Forwardable
      include Errors

      attr_reader :types, :formatter, :path

      delegate %w(
        output
        error_output
        dep_output
        check_start_output
        check_finish_output
      ) => :formatter

      def initialize(types:, formatter:, path:)
        @types = types
        @formatter = formatter
        @path = path
      end
    end
  end
end
