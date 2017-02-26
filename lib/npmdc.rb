module Npmdc
  require "npmdc/config"
  require "npmdc/checkers/checker"
  require "npmdc/version"

  class << self
    def call(options = {})
      Npmdc::Checkers::Checker.new(options).call

    rescue Npmdc::Errors::ConfigurationError => e
      abort(e.banner)
    end

    def config
      @config ||= Config.new
    end

    def configure
      yield config
    end
  end

  require "npmdc/railtie" if defined?(Rails)
end
