require "npmdc/checker"
require "npmdc/engine" if defined?(Rails)
require "npmdc/version"

module Npmdc
  class << self
    attr_writer :output

    def call(options = {})
      Npmdc::Checker.new(options).call
    end

    def output
      @output ||= STDOUT
    end
  end
end
