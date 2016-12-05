require 'npmdc'

module Npmdc
  class Engine < Rails::Engine # :nodoc:
    config.npmdc = ActiveSupport::OrderedOptions.new

    initializer "npmdc.load_hook" do |app|
      options = app.config.npmdc
      options.path ||= Rails.root
      Npmdc.call(options.stringify_keys)
    end
  end
end
