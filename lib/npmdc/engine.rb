require 'npmdc'

module Npmdc
  class Engine < Rails::Engine # :nodoc:
    config.npmdc = ActiveSupport::OrderedOptions.new

    initializer "run Npmdc on start-up" do |app|
      options = app.npmdc
      options.path ||= Rails.root
      Npmdc.call(options)
    end
  end
end
