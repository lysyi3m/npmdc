module Npmdc
  require "npmdc/config"
  require "npmdc/checker"
  require "npmdc/version"

  class << self
    def call(options = {})
      Npmdc::Checker.new(options).call

    rescue Npmdc::Errors::ConfigurationError => e
      Npmdc.config.output.puts e.banner

      false
    end

    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end

  require "npmdc/engine" if defined?(Rails)
end
