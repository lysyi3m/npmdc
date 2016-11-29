require 'rails'

class Npmdc::Railtie < Rails::Railtie
  config.npmdc = ActiveSupport::OrderedOptions.new

  initializer "npmdc" do |app|
    Npmdc.call(app.config.npmdc[:options])
  end
end
