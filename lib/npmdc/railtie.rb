require 'rails'

module Npmdc
  class Railtie < Rails::Railtie
    config.npmdc = ActiveSupport::OrderedOptions.new

    initializer 'npmdc' do |app|
      options = {
        :path => app.config.npmdc[:path] || Rails.root,
        :verbose => app.config.npmdc[:verbose]
      }

      Npmdc.call(options)
    end
  end
end
