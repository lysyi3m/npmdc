require "npmdc/checker"
require "npmdc/railtie" if defined?(Rails)
require "npmdc/version"

module Npmdc
  def self.call(options = {})
    Npmdc::Checker.new(options).call
  end
end
